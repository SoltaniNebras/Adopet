import 'package:adopet/models/Owner.dart';

class Dog {
  final int id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String location;
  final String imagePath;
  final String description;
  final Owner owner;
  final String personality; 

  Dog(
    this.id,
    this.name,
    this.age,
    this.gender,
    this.color,
    this.weight,
    this.location,
    this.imagePath,
    this.description,
    this.owner,
    this.personality, 
  );
}
