import 'package:flutter/material.dart';
import 'models/Dog.dart';
import 'api_service.dart';
import 'pet_details.dart';

void main() {
  runApp(MyApp()); // Ensure the main() function is defined and calls runApp.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Adopet - Dogs for Adoption',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PetListScreen(),
    );
  }
}

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<Dog>> dogs;

  @override
  void initState() {
    super.initState();
    dogs = ApiService().fetchDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adopet - Dogs for Adoption")),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            dogs = ApiService().fetchDogs();
          });
        },
        child: FutureBuilder<List<Dog>>(
          future: dogs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              debugPrint("Error fetching dogs: ${snapshot.error}");
              return Center(child: Text("Error loading data"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No Dogs available"));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final dog = snapshot.data![index];
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
                                child: Image.network(
                                  dog.imagePath,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image, size: 70, color: Colors.grey);
                                  },
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
                                        Text(dog.distance),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: dog.gender == "Male"
                                      ? Colors.blue[100]
                                      : dog.gender == "Female"
                                          ? Colors.pink[100]
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  dog.gender,
                                  style: TextStyle(
                                    color: dog.gender == "Male"
                                        ? Colors.blue
                                        : dog.gender == "Female"
                                            ? Colors.pink
                                            : Colors.grey,
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
              );
            }
          },
        ),
      ),
    );
  }
}
