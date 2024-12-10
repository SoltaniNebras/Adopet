import 'Owner.dart';

class Dog {
  final String id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String distance;
  final String imagePath;
  final String description;
  //final Owner owner;
  final String personality;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.distance,
    required this.imagePath,
    required this.description,
   // required this.owner,
    required this.personality,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      color: json['color'],
      weight: json['weight'],
      distance: json['distance'],
      imagePath:json['imagePath'],
      description: json['description'],
      //owner: Owner.fromJson(json['owner']),
      personality: json['personality'],
    );
  }
   Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "gender": gender,
      "color": color,
      "weight": weight,
      "distance": distance,
      "imagePath": imagePath,
      "description": description,
      "personality": personality,
      //"owner": owner.toJson(),
    };
  }
}
