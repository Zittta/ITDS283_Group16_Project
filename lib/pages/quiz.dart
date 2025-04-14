import 'package:flutter/material.dart';
import 'quizzing.dart';

class Quiz extends StatefulWidget {
  final int folderId;
  final String folderName;

  const Quiz({super.key, required this.folderName, required this.folderId});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String? selectedQuestionType = "Front"; // Default value
  int selectedNumberOfQuestions = 5; // Default number

  @override
  Widget build(BuildContext context) {
    String folderName = widget.folderName;
    int folderId = widget.folderId;

    return Scaffold(
      appBar: AppBar(
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
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Select Question Type label
                const Text("Select Question Type:",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                // Radio buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(width: 30),
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
                const SizedBox(height: 40),

                // Number of Questions label
                const Text("Number of Questions:",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

                // Dropdown
                DropdownButton<int>(
                  value: selectedNumberOfQuestions,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedNumberOfQuestions = newValue!;
                    });
                  },
                  items: [5, 10, 15, 20].map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizzingPage(folderId: folderId),
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
