import 'dart:io';
import 'dart:typed_data';
import 'package:adopet/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personalityController = TextEditingController();

  String? _selectedGender; // Variable pour stocker la sélection du genre

  File? _selectedImage;
  Uint8List? _webImageBytes;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final dogData = {
        "name": nameController.text,
        "age": double.tryParse(ageController.text) ?? 0.0,
        "gender": _selectedGender ?? "",
        "color": colorController.text,
        "weight": double.tryParse(weightController.text) ?? 0.0,
        "distance": distanceController.text,
        "description": descriptionController.text,
        "personality": personalityController.text,
      };

      try {
        await ApiService.addDog(dogData, _selectedImage, _webImageBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Chien ajouté avec succès !")),
        );

        await Future.delayed(Duration(seconds: 2));

        context.go('/');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l'ajout du chien : $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Chien"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextFormField(
                  nameController,
                  "Nom",
                  "Entrez un nom",
                  Icons.pets,
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  ageController,
                  "Âge",
                  "Entrez l'âge",
                  Icons.cake,
                  isNumber: true,
                ),
                SizedBox(height: 15),
                // Boutons radio pour le sexe
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sexe", style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Male",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text("Male"),
                        Radio<String>(
                          value: "Femelle",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text("Femelle"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  colorController,
                  "Couleur",
                  "Entrez la couleur",
                  Icons.color_lens,
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  weightController,
                  "Poids",
                  "Entrez le poids (kg)",
                  Icons.scale,
                  isNumber: true,
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  distanceController,
                  "Distance",
                  "Distance approximative",
                  Icons.map,
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  descriptionController,
                  "Description",
                  "Décrivez le chien",
                  Icons.description,
                  maxLines: 3,
                ),
                SizedBox(height: 15),
                _buildTextFormField(
                  personalityController,
                  "Personnalité",
                  "Décrivez la personnalité",
                  Icons.mood,
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: _webImageBytes != null || _selectedImage != null
                        ? kIsWeb
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  _webImageBytes!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                        : Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orangeAccent, width: 2),
                            ),
                            child: Icon(Icons.add_a_photo, color: Colors.orangeAccent, size: 40),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.orangeAccent,
                      ),
                      child: Text("Ajouter", style: TextStyle(fontSize: 16)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        nameController.clear();
                        ageController.clear();
                        colorController.clear();
                        weightController.clear();
                        distanceController.clear();
                        descriptionController.clear();
                        personalityController.clear();
                        setState(() {
                          _selectedImage = null;
                          _webImageBytes = null;
                          _selectedGender = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        side: BorderSide(color: Colors.orangeAccent, width: 2),
                      ),
                      child: Text("Réinitialiser", style: TextStyle(fontSize: 16, color: Colors.orangeAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    String? validationMessage,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validationMessage ?? "Ce champ est requis";
        }
        if (isNumber && double.tryParse(value) == null) {
          return "Veuillez entrer un nombre valide";
        }
        return null;
      },
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
    );
  }
}
