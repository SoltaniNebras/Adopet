import 'dart:io';
import 'package:adopet/api_service.dart';
import 'package:adopet/models/Dog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class EditDogScreen extends StatefulWidget {
  final Dog? dog;

  const EditDogScreen({super.key, required this.dog});

  @override
  _EditDogScreenState createState() => _EditDogScreenState();
}

class _EditDogScreenState extends State<EditDogScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _personalityController;
  late TextEditingController _distanceController;
  late TextEditingController _weightController;
  late TextEditingController _descriptionController; // New controller for description
  late String _gender;
  late String _color;
  XFile? _imageFile;
  Uint8List? _imageBytes; // For Flutter Web

  @override
  void initState() {
    super.initState();

    // Initialize controllers and default values
    _nameController = TextEditingController(text: widget.dog?.name ?? '');
    _ageController = TextEditingController(text: widget.dog?.age.toString() ?? '');
    _personalityController = TextEditingController(text: widget.dog?.personality ?? '');
    _distanceController = TextEditingController(text: widget.dog?.distance ?? '');
    _weightController = TextEditingController(text: widget.dog?.weight.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.dog?.description ?? ''); // Initialize for description
    _gender = widget.dog?.gender ?? 'Male';
    _color = widget.dog?.color ?? '';
  }

  @override
  void dispose() {
    // Release resources
    _nameController.dispose();
    _ageController.dispose();
    _personalityController.dispose();
    _distanceController.dispose();
    _weightController.dispose();
    _descriptionController.dispose(); // Release description controller
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        _imageBytes = await pickedFile.readAsBytes();
      } else {
        _imageFile = pickedFile;
      }
      setState(() {});
    }
  }

  Future<void> _updateDog() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _color.isEmpty ||
        _descriptionController.text.isEmpty) {  // Check for description
      _showSnackbar('Veuillez remplir tous les champs');
      return;
    }

    final double? age = double.tryParse(_ageController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (age == null || weight == null) {
      _showSnackbar('L\'âge et le poids doivent être des nombres valides');
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
      description: _descriptionController.text, 
      personality: _personalityController.text,
    );

    try {
      await ApiService.updateDog(updatedDog, _imageFile, _imageBytes);
      _showSnackbar('Chien mis à jour avec succès');
      await Future.delayed(Duration(seconds: 2));
      context.go('/list');  
    } catch (e) {
      _showSnackbar('Erreur lors de la mise à jour');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un Chien"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller: _nameController, label: 'Nom', icon: Icons.pets),
              _buildTextField(controller: _ageController, label: 'Âge', icon: Icons.cake, keyboardType: TextInputType.number),
              _buildGenderSelection(),
              _buildTextField(
                controller: TextEditingController(text: _color),
                label: 'Couleur',
                icon: Icons.palette,
                onChanged: (value) => setState(() => _color = value),
              ),
              _buildTextField(controller: _weightController, label: 'Poids', icon: Icons.scale, keyboardType: TextInputType.number),
              _buildTextField(controller: _distanceController, label: 'Distance', icon: Icons.map),
              _buildTextField(controller: _descriptionController, label: 'Description', icon: Icons.description, maxLines: 3),
              _buildTextField(controller: _personalityController, label: 'Personnalité', icon: Icons.emoji_emotions),
              SizedBox(height: 20),
              _buildImageButton(),
              SizedBox(height: 10),
              _buildImagePreview(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Mettre à jour'),
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
    int maxLines = 1,  // Added maxLines parameter for flexible multi-line input
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
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
              onChanged: (value) => setState(() => _gender = value!),
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: Text("Femelle"),
              value: "Female",
              groupValue: _gender,
              onChanged: (value) => setState(() => _gender = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageButton() {
    return ElevatedButton.icon(
      onPressed: _pickImage,
      icon: Icon(Icons.image, color: Colors.white),
      label: Text('Sélectionner une image'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 5,
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, fit: BoxFit.cover);
    } else if (_imageFile != null) {
      return Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    } else if (widget.dog?.imagePath.isNotEmpty ?? false) {
      return Image.network("http://localhost:5000${widget.dog!.imagePath}", fit: BoxFit.cover);
    } else {
      return Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey);
    }
  }
}
