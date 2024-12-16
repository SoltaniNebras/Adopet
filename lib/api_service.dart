
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'models/Dog.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/dogs";

  static Future<List<Dog>> fetchDogs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          return [];
        }

        return data
            .whereType<Map<String, dynamic>>()
            .map((dog) => Dog.fromJson(dog))
            .toList();
      } else {
        throw Exception("Failed to load dogs: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<void> addDog(Map<String, dynamic> dogData, File? imagePath, Uint8List? webImage) async {
    try {
      var uri = Uri.parse(baseUrl);
      var request = http.MultipartRequest('POST', uri);

      dogData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imagePath != null) {
        // Mobile/Desktop case: Use MultipartFile fromPath
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath',
          imagePath.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (webImage != null) {
        // Web case: Use MultipartFile fromBytes
        request.files.add(http.MultipartFile.fromBytes(
          'imagePath',
          webImage,
          filename: 'imagePath.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();
      if (response.statusCode == 201) {
        print("Dog added successfully");
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Failed to add dog, status code: ${response.statusCode}");
        print("Response body: $responseBody");
        throw Exception("Failed to add dog");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error uploading dog data");
    }
  }

  static Future<void> deleteDog(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        print("Dog deleted successfully");
      } else {
        print("Failed to delete dog, status code: ${response.statusCode}");
        throw Exception("Failed to delete dog");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error deleting dog");
    }
  }

  static Future<void> updateDog(Dog dog, XFile? imageFile, Uint8List? webImage) async {
  try {
    var uri = Uri.parse("$baseUrl/${dog.id}");
    var request = http.MultipartRequest('PUT', uri);

      // Add dog fields
      request.fields['name'] = dog.name;
      request.fields['age'] = dog.age.toString();
      request.fields['personality'] = dog.personality;
      request.fields['distance'] = dog.distance;
      request.fields['gender'] = dog.gender;
      request.fields['color'] = dog.color;
      request.fields['description'] = dog.description;
      request.fields['weight'] = dog.weight.toString();

       if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'imagePath',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (webImage != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'imagePath',
        webImage,
        filename: 'imagePath.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception("Failed to update dog: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error updating dog: $e");
  }
}}