import 'package:flutter/material.dart';

class AddEditCard extends StatefulWidget {
  final int? index; // To identify if we're editing
  final Map<String, dynamic>? cardData; // To pass the card data for editing

  const AddEditCard({
    super.key,
    this.index,
    this.cardData,
  });

  @override
  _AddEditCardState createState() => _AddEditCardState();
}

class _AddEditCardState extends State<AddEditCard> {
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  late TextEditingController _meaningController;
  late List<TextEditingController> _answerControllers;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers
    _titleController = TextEditingController(
      text: widget.cardData != null ? widget.cardData!['title'] : '',
    );
    _memoController = TextEditingController(
      text: widget.cardData != null ? widget.cardData!['memo'] : '',
    );
    _meaningController = TextEditingController(
      text: widget.cardData != null ? widget.cardData!['meaning'] : '',
    );
    _answerControllers = List.generate(
      4,
      (i) => TextEditingController(
        text: widget.cardData != null && widget.cardData!['answers'] != null
            ? widget.cardData!['answers'][i]
            : '',
      ),
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

    // Ensure that title, meaning, and answers are not empty
    if (title.isEmpty || meaning.isEmpty || answers.any((a) => a.isEmpty)) return;

    final cardData = {
      'title': title,
      'memo': memo,
      'meaning': meaning,
      'answers': answers,
    };

    Navigator.pop(context, cardData); // Pass the data back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.index == null ? 'Add Card' : 'Edit Card')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 12),
            const Text("Answers"),
            const SizedBox(height: 8),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _answerControllers[i],
                  decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
                ),
              ),
            const SizedBox(height: 16),
            
            // Photo selection button changed to icon
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo selection will be done later.')),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveCard,
              child: Text(widget.index == null ? 'Add Card' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
