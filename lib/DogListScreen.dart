import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'models/Dog.dart';
import 'api_service.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<Dog>> _dogsFuture;

  @override
  void initState() {
    super.initState();
    _dogsFuture = ApiService.fetchDogs();
  }

  // Delete dog and refresh the list after confirmation
  Future<void> _deleteDog(Dog dog) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la suppression"),
        content: Text("Êtes-vous sûr de vouloir supprimer ce chien ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await ApiService.deleteDog(dog.id);
        setState(() {
          _dogsFuture = ApiService.fetchDogs(); // Refresh the list after deletion
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Chien supprimé avec succès")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression du chien")),
        );
      }
    }
  }
Widget _buildDogCard(Dog dog) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image du chien
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "http://localhost:5000${dog.imagePath}",
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.pets, size: 80, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // Détails du chien
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dog.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${dog.age.toStringAsFixed(1)} yrs | ${dog.personality}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      dog.distance,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Genre du chien (icône colorée)
          Container(
            decoration: BoxDecoration(
              color: dog.gender.toLowerCase() == "male"
                  ? Colors.blue[100]
                  : Colors.pink[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              dog.gender,
              style: TextStyle(
                color: dog.gender.toLowerCase() == "male"
                    ? Colors.blue
                    : Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Edit and Delete buttons
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  context.go('/edit', extra: dog); // Navigate to the Edit screen
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteDog(dog),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adopet - Dogs for Adoption"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _dogsFuture = ApiService.fetchDogs();
          });
        },
        child: FutureBuilder<List<Dog>>(
          future: _dogsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("Aucun chien disponible à l'adoption."),
              );
            } else {
              final dogs = snapshot.data!;
              return ListView.builder(
                itemCount: dogs.length,
                itemBuilder: (context, index) {
                  final dog = dogs[index];
                  return GestureDetector(
                    onTap: () {
                      context.go('/details', extra: dog);
                    },
                    child: _buildDogCard(dog),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add');
        },
        tooltip: 'Ajouter un chien',
        child: Icon(Icons.add),
      ),
    );
  }
}
