import 'dart:io';
import 'package:adopet/api_service.dart';
import 'package:adopet/models/Dog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class EditDogScreen extends StatefulWidget {
  final Dog? dog;

  EditDogScreen({required this.dog});

  @override
  _EditDogScreenState createState() => _EditDogScreenState();
}

class _EditDogScreenState extends State<EditDogScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _personalityController;
  late TextEditingController _distanceController;
  late TextEditingController _weightController;
  late String _gender;
  late String _color;
  late XFile? _imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.dog != null) {
      _nameController = TextEditingController(text: widget.dog!.name);
      _ageController = TextEditingController(text: widget.dog!.age.toString());
      _personalityController = TextEditingController(text: widget.dog!.personality);
      _distanceController = TextEditingController(text: widget.dog!.distance);
      _weightController = TextEditingController(text: widget.dog!.weight.toString());
      _gender = widget.dog!.gender;
      _color = widget.dog!.color;
    } else {
      _nameController = TextEditingController();
      _ageController = TextEditingController();
      _personalityController = TextEditingController();
      _distanceController = TextEditingController();
      _weightController = TextEditingController();
      _gender = 'Male';
      _color = '';
    }
    _imageFile = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _personalityController.dispose();
    _distanceController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _updateDog() async {
    if (_nameController.text.isEmpty || 
        _ageController.text.isEmpty || 
        _weightController.text.isEmpty || 
        _color.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    double? age = double.tryParse(_ageController.text);
    double? weight = double.tryParse(_weightController.text);

    if (age == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('L\'âge et le poids doivent être des nombres valides')));
      return;
    }

    final updatedDog = Dog(
      id: widget.dog?.id ?? '',
      name: _nameController.text,
      age: age,
      gender: _gender,
      color: _color,
      weight: weight,
      distance: _distanceController.text,
      imagePath: _imageFile?.path ?? widget.dog?.imagePath ?? '',
      description: widget.dog?.description ?? '',
      personality: _personalityController.text,
    );

    try {
      await ApiService.updateDog(updatedDog, _imageFile);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chien mis à jour")),
      );

      await Future.delayed(Duration(seconds: 2));

      context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Chien"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nom',
                icon: Icons.pets,
              ),
              _buildTextField(
                controller: _ageController,
                label: 'Âge',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              _buildGenderSelection(),
              _buildTextField(
                controller: TextEditingController(text: _color),
                label: 'Couleur',
                icon: Icons.palette,
                onChanged: (value) => setState(() {
                  _color = value;
                }),
              ),
              _buildTextField(
                controller: _weightController,
                label: 'Poids',
                icon: Icons.scale,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _distanceController,
                label: 'Distance',
                icon: Icons.map,
              ),
              _buildTextField(
                controller: _personalityController,
                label: 'Personnalité',
                icon: Icons.emoji_emotions,
              ),
              SizedBox(height: 20),
             ElevatedButton.icon(
  onPressed: _pickImage,
  icon: Icon(Icons.image, color: Colors.white),
  label: Text('Sélectionner une image'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Coins arrondis
    ),
    elevation: 5, // Ombre pour un effet en relief
  ),
),

              if (_imageFile != null || (widget.dog?.imagePath.isNotEmpty ?? false))
                SizedBox(
                  height: 100,
                  child: _imageFile != null
                      ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                      : Image.network(
                          "http://localhost:5000${widget.dog?.imagePath}",
                          fit: BoxFit.cover,
                        ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDog,
                child: Text('Mettre à jour'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<String>(
              title: Text("Male"),
              value: "Male",
              groupValue: _gender,
              onChanged: (value) => setState(() {
                _gender = value!;
              }),
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: Text("Femelle"),
              value: "Female",
              groupValue: _gender,
              onChanged: (value) => setState(() {
                _gender = value!;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
