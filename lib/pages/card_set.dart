import 'package:flutter/material.dart';

class CardSet extends StatefulWidget {
  const CardSet({super.key});

  @override
  State<CardSet> createState() => _CardSetState();
}

class _CardSetState extends State<CardSet> {
  final List<Map<String, dynamic>> cards = [];

  void _addCard(String title, String memo, List<String> answers) {
    setState(() {
      cards.add({
        'title': title,
        'memo': memo,
        'answers': answers,
      });
    });
  }

  void _editCard(int index, String title, String memo, List<String> answers) {
    setState(() {
      cards[index] = {
        'title': title,
        'memo': memo,
        'answers': answers,
      };
    });
  }

  void _showCardDialog({int? index}) {
    final titleController = TextEditingController(
        text: index != null ? cards[index]['title'] : '');
    final memoController = TextEditingController(
        text: index != null ? cards[index]['memo'] : '');
    final List<TextEditingController> answerControllers = List.generate(
      4,
      (i) => TextEditingController(
        text: index != null ? cards[index]['answers'][i] : '',
      ),
    );

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Card Title (Question)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(labelText: 'Card Memo'),
              ),
              const SizedBox(height: 12),
              const Text("Answers"),
              const SizedBox(height: 8),
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: answerControllers[i],
                    decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final memo = memoController.text.trim();
                  final answers = answerControllers.map((c) => c.text.trim()).toList();

                  if (title.isEmpty || answers.any((a) => a.isEmpty)) return;

                  if (index == null) {
                    _addCard(title, memo, answers);
                  } else {
                    _editCard(index, title, memo, answers);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(index == null ? 'Add Card' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Card set')),
      body: Center(child: Text('Card set', style: TextStyle(fontSize: 24))),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //task04
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
