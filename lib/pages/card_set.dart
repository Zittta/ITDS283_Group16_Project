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
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: const Text('new folder-1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCardDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Card"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card List
            Expanded(
              child: cards.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "There are no cards to display.\nPlease press 'Add Card' to create a card",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                cards[index]['title'],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showCardDialog(index: index),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
