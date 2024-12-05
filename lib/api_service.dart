import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/Dog.dart';

class ApiService {
  final String baseUrl = "http://localhost:5000/api/dogs"; 

  Future<List<Dog>> fetchDogs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((dog) => Dog.fromJson(dog)).toList();
      } else {
        throw Exception("Failed to load dogs");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
