import 'package:flutter/material.dart';
import '../database/database_helper.dart'; // Adjust path as needed

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
  late List<TextEditingController> _answerControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.cardData['question']);
    _memoController = TextEditingController(text: widget.cardData['memo']);
    _meaningController = TextEditingController(text: widget.cardData['meaning']);
    final answers = (widget.cardData['answer'] as String?)?.split('|') ?? List.filled(4, '');
    _answerControllers = List.generate(4, (i) => TextEditingController(text: i < answers.length ? answers[i] : ''));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _meaningController.dispose();
    for (var c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveCard() async {
    final title = _titleController.text.trim();
    final memo = _memoController.text.trim();
    final meaning = _meaningController.text.trim();
    final answers = _answerControllers.map((c) => c.text.trim()).toList();

    if (title.isEmpty || meaning.isEmpty || answers.any((a) => a.isEmpty)) return;

    final joinedAnswers = answers.join('|');

    await DatabaseHelper().updateCard(
      widget.cardId,
      title,
      joinedAnswers,
      meaning,
      memo,
      photo: null, // Add photo later
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
                const SnackBar(content: Text('Photo selection will be added later.')),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _saveCard, child: const Text('Save Changes')),
        ],
      ),
    );
  }
}
