import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AddDogScreen.dart';
import 'EditDogScreen.dart';
import 'DogListScreen.dart';
import 'pet_details.dart';
import 'models/Dog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/list',
        builder: (context, state) => PetListScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => AddDogScreen(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final dog = state.extra as Dog;
          return PetDetailsScreen(dog: dog);
        },
      ),
      GoRoute(
        path: '/edit',
        builder: (context, state) {
          final dog = state.extra as Dog;
          return EditDogScreen(dog: dog);
        },
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Adopet - Dogs for Adoption',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 242, 234, 255), Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image circulaire avec un cadre coloré
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/adopt.png', // Assurez-vous d'ajouter une image dans le dossier assets
                    width: 500,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Texte principal
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: [
                  TextSpan(
                    text: "Find ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  TextSpan(
                    text: "Your Best  🐶  ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "With Us",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Join & discover the best suitable pets in\nyour location or near you.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            // Button Explore
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), backgroundColor: const Color.fromARGB(255, 120, 169, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadowColor: Colors.black12,
                elevation: 10,
              ),
              child: Icon(
                Icons.pets,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                context.go('/list'); // Navigate to /list when pressed
              },
            ),
          ],
        ),
      ),
    );
  }
}
