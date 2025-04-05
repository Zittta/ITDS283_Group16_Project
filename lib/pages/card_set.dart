import 'package:flutter/material.dart';
import 'add_edit_card.dart';


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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: const Text('New Folder - 1'),
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
                  onPressed: () async {
                    final newCard = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditCard(index: null), // Add card without editing
                      ),
                    );

                    if (newCard != null) {
                      _addCard(newCard['title'], newCard['memo'], newCard['answers']);
                    }
                  },
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
                                  onPressed: () async {
                                    final updatedCard = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddEditCard(
                                          index: index, // Editing a specific card
                                          cardData: cards[index],
                                        ),
                                      ),
                                    );

                                    if (updatedCard != null) {
                                      _editCard(
                                        index,
                                        updatedCard['title'],
                                        updatedCard['memo'],
                                        updatedCard['answers'],
                                      );
                                    }
                                  },
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
