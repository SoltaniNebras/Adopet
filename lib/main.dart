import 'package:adopet/Data.dart';
import 'package:flutter/material.dart';
import 'models/Dog.dart';
import 'models/Owner.dart';
import 'pet_details.dart';

void main() {
  runApp(AdopetApp());
}

class AdopetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopet',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PetListScreen(),
    );
  }
}
class PetListScreen extends StatelessWidget {
  final Owner owner = Owner("Spikey Sanju", "Developer & Pet Lover", "assets/owner.jpg");
  final List<Dog> dogs = dogList; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adopet - Pets for Adoption")),
      body: ListView.builder(
        itemCount: dogs.length,
        itemBuilder: (context, index) {
          final dog = dogs[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailsScreen(dog: dog),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          dog.imagePath,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dog.name,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${dog.age} yrs | ${dog.personality}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.red),
                                SizedBox(width: 5),
                                Text(dog.location),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: dog.gender == "Male" ? Colors.blue[100] : Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          dog.gender,
                          style: TextStyle(
                            color: dog.gender == "Male" ? Colors.blue : Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
