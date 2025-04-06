import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String? selectedQuestionType = "Front"; // Default value
  int selectedNumberOfQuestions = 5; // Default number

  @override
  Widget build(BuildContext context) {
    String folderName = "Folder name"; // Replace dynamically if needed

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's get Started!"),
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40), // Increased spacing

                // Select Question Type label
                Text(
                  "Select Question Type:",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

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
                    Text("Front Question"),
                    SizedBox(width: 30),
                    Radio<String>(
                      value: "Back",
                      groupValue: selectedQuestionType,
                      onChanged: (value) {
                        setState(() {
                          selectedQuestionType = value;
                        });
                      },
                    ),
                    Text("Back Question"),
                  ],
                ),
                SizedBox(height: 40), // Increased spacing

                // Number of Questions label
                Text(
                  "Number of Questions:",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

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
                SizedBox(height: 40), // Increased spacing

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/quizzing',
                    );
                  },
                  child: Text("Start Quiz"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
