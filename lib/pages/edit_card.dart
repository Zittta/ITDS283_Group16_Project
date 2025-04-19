import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';

class EditCard extends StatefulWidget {
  final int cardId;
  final Map<String, dynamic> cardData;

  const EditCard({super.key, required this.cardId, required this.cardData});

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  late TextEditingController _meaningController;
  String? _selectedImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.cardData['question']);
    _memoController = TextEditingController(text: widget.cardData['memo']);
    _meaningController = TextEditingController(text: widget.cardData['meaning']);
    _selectedImagePath = widget.cardData['photo'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final action = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1),
              child: const Text('Use Camera'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2),
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
          _selectedImagePath = image.path;
        });
      }
    } else if (action == 2) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    }
  }

  void _saveCard() async {
    final title = _titleController.text.trim();
    final memo = _memoController.text.trim();
    final meaning = _meaningController.text.trim();

    if (title.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    await DatabaseHelper().updateCard(
      widget.cardId,
      title,
      meaning,
      memo,
      photo: _selectedImagePath,
    );

    Navigator.pop(context, true); // Return true to trigger refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Card')),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
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

          // Image preview
          if (_selectedImagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_selectedImagePath!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Change Photo"),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveCard,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
