import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '/pages/add_card.dart';
import '/pages/edit_card.dart';
import 'dart:io'; // Import to use File class for images

class CardSet extends StatefulWidget {
  final String folderName;
  final int folderId;

  const CardSet({super.key, required this.folderName, required this.folderId});

  @override
  State<CardSet> createState() => _CardSetState();
}

class _CardSetState extends State<CardSet> {
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final loadedCards = await DatabaseHelper().getCards(widget.folderId);
    setState(() {
      cards = loadedCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.05) // Lighter shadow for dark theme
        : Colors.black.withOpacity(0.05); // Standard shadow for light theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          widget.folderName,
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCard(folderId: widget.folderId),
                      ),
                    );

                    if (result == true) {
                      _loadCards(); // refresh list
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
                        final card = cards[index];
                        final answers = card['answer']?.split('|') ?? [];
                        final imagePath = card['photo']; // Get the photo path

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor, // Apply dynamic shadow color
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show image if it exists
                              if (imagePath != null && imagePath.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(imagePath), // Display the image from the path
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  color: Colors.blue[50],
                                  child: const Center(
                                    child: FlutterLogo(size: 60),
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                card['question'] ?? '',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (card['meaning'] != null &&
                                  card['meaning'].toString().isNotEmpty)
                                Text(
                                  "Meaning: ${card['meaning']}",
                                  style: theme.textTheme.bodyMedium,
                                ),
                              const SizedBox(height: 6),
                              if (answers.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Answers:"),
                                    for (final ans in answers)
                                      Text("- $ans",
                                          style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              const SizedBox(height: 12),

                              // The row for delete and edit icons at the bottom of each card
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await DatabaseHelper()
                                          .deleteCard(card['id']);
                                      _loadCards(); // Refresh after delete
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditCard(
                                            cardId: card['id'],
                                            cardData: card,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadCards(); // Refresh list after editing
                                      }
                                    },
                                  ),
                                ],
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
