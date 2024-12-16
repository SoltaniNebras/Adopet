import 'package:flutter/material.dart';
import 'models/Dog.dart';

class PetDetailsScreen extends StatelessWidget {
  final Dog dog;

  const PetDetailsScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    // Gérer les chemins relatifs ou absolus
    final imageUrl = dog.imagePath.startsWith('http')
        ? dog.imagePath
        : 'http://localhost:5000${dog.imagePath}';

    return Scaffold(
      appBar: AppBar(title: Text(dog.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.error,
                        size: 100,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // Nom et informations principales
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dog.name,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            dog.distance,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${dog.age} yrs | ${dog.personality}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            SizedBox(height: 16),

            // Section "About Me"
            Text(
              "About me",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              dog.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),

            // Informations supplémentaires
            Text(
              "Quick Info",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile("Age", "${dog.age} yrs"),
                _buildInfoTile("Color", dog.color),
                _buildInfoTile("Weight", "${dog.weight} kg"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
