import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Adjust path as needed

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
  final List<TextEditingController> _answerControllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _meaningController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveCard() async {
    final title = _titleController.text.trim();
    final memo = _memoController.text.trim();
    final meaning = _meaningController.text.trim();
    final answers = _answerControllers.map((c) => c.text.trim()).toList();

    if (title.isEmpty || meaning.isEmpty || answers.any((a) => a.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final answerString = answers.join('|'); // Store answers as delimited string

      await DatabaseHelper().insertCard(
    widget.folderId,
    title,
    answerString,
    meaning,
    memo,
    photo: null,
  );

    Navigator.pop(context, true); // Return to previous screen
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
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Card Title')),
          const SizedBox(height: 12),
          TextField(controller: _memoController, decoration: const InputDecoration(labelText: 'Card Memo')),
          const SizedBox(height: 12),
          TextField(controller: _meaningController, decoration: const InputDecoration(labelText: 'Card Meaning')),
          const SizedBox(height: 12),
          const Text("Answers"),
          for (int i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: _answerControllers[i],
                decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
              ),
            ),
          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo selection will be done later.')),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _saveCard, child: const Text('Add Card')),
        ],
      ),
    );
  }
}
