import 'package:flutter/material.dart';

class EditCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> cardData;

  const EditCard({super.key, required this.index, required this.cardData});

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
    _titleController = TextEditingController(text: widget.cardData['title']);
    _memoController = TextEditingController(text: widget.cardData['memo']);
    _meaningController = TextEditingController(text: widget.cardData['meaning']);
    _answerControllers = List.generate(
      4,
      (i) => TextEditingController(text: widget.cardData['answers'][i]),
    );
  }

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

  void _saveCard() {
    final title = _titleController.text.trim();
    final memo = _memoController.text.trim();
    final meaning = _meaningController.text.trim();
    final answers = _answerControllers.map((c) => c.text.trim()).toList();

    if (title.isEmpty || meaning.isEmpty || answers.any((a) => a.isEmpty)) return;

    final cardData = {
      'title': title,
      'memo': memo,
      'meaning': meaning,
      'answers': answers,
    };

    Navigator.pop(context, cardData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Card')),
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
          ElevatedButton(onPressed: _saveCard, child: const Text('Save Changes')),
        ],
      ),
    );
  }
}
