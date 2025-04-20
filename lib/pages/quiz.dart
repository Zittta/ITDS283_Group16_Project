import 'package:flutter/material.dart';
import 'quizzing.dart';
import '../database/database_helper.dart';

class Quiz extends StatefulWidget {
  final int folderId;
  final String folderName;

  const Quiz({super.key, required this.folderName, required this.folderId});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String? selectedQuestionType = "Front"; // Default value
  int? selectedNumberOfQuestions = 5; // Now allows "All" as null

  @override
  Widget build(BuildContext context) {
    String folderName = widget.folderName;
    int folderId = widget.folderId;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/folders',
              (route) => false,
            );
          },
        ),
        title: const Text("Let's get Started!"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Folder name
                Text(
                  folderName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Select Question Type label
                const Text("Select Question Type:",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                // Radio buttons (Wrap to avoid overflow)
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 30,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: "Front",
                          groupValue: selectedQuestionType,
                          onChanged: (value) {
                            setState(() {
                              selectedQuestionType = value;
                            });
                          },
                        ),
                        const Text("Front Question"),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: "Back",
                          groupValue: selectedQuestionType,
                          onChanged: (value) {
                            setState(() {
                              selectedQuestionType = value;
                            });
                          },
                        ),
                        const Text("Back Question"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Number of Questions label
                const Text("Number of Questions:",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                // Dropdown
                DropdownButton<int?>(
                  value: selectedNumberOfQuestions,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedNumberOfQuestions = newValue;
                    });
                  },
                  items: [5, 10, 15, null].map((value) {
                    return DropdownMenuItem<int?>(
                      value: value,
                      child: Text(value == null ? "All" : "$value"),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // Start Button
                ElevatedButton(
                  onPressed: () async {
                    final allCards = await DatabaseHelper().getCards(folderId);

                    final numCardsAvailable = allCards.length;
                    final numQuestions =
                        selectedNumberOfQuestions ?? numCardsAvailable;

                    if (numCardsAvailable < numQuestions) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Not Enough Cards"),
                          content: Text(
                            "You selected $numQuestions questions, but only $numCardsAvailable cards are available in this folder.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizzingPage(
                          folderId: folderId,
                          selectedQuestionType:
                              selectedQuestionType ?? "Front",
                          totalQuestions: numQuestions,
                        ),
                      ),
                    );
                  },
                  child: const Text("Start Quiz"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
