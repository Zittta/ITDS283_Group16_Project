import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Adjust path as needed
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCard extends StatefulWidget {
  final int folderId;

  const AddCard({super.key, required this.folderId});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _titleController = TextEditingController();
  final _memoController = TextEditingController();
  final _meaningController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    final title = _titleController.text.trim();
    final memo = _memoController.text.trim();
    final meaning = _meaningController.text.trim();

    if (title.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    await DatabaseHelper().insertCard(
      widget.folderId,
      title,
      meaning,
      memo,
      photo: _selectedImage?.path, // Pass the image path if selected
    );

    Navigator.pop(context, true); // Return to previous screen
  }

  Future<void> _pickImage() async {
    final action = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1); // Use Camera
              },
              child: const Text('Use Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 2); // Use Gallery
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
        );
      },
    );

    if (action == 1) {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } else if (action == 2) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Card Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _memoController,
            decoration: const InputDecoration(labelText: 'Card Memo'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _meaningController,
            decoration: const InputDecoration(labelText: 'Card Meaning'),
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _pickImage,
          ),
          const SizedBox(height: 16),
          // Display the selected image
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 200, // You can adjust the height based on your needs
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveCard,
            child: const Text('Add Card'),
          ),
        ],
      ),
    );
  }
}
