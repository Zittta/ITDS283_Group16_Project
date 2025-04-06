import 'package:flutter/material.dart';

class QuizzingPage extends StatefulWidget {
  @override
  _QuizzingPageState createState() => _QuizzingPageState();
}

class _QuizzingPageState extends State<QuizzingPage> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<int> userSelections = [];

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is Flutter?',
      'options': ['A bird', 'A UI toolkit', 'A database', 'A game engine'],
      'answerIndex': 1,
    },
    {
      'question': 'What language is used in Flutter?',
      'options': ['Python', 'Java', 'Dart', 'Kotlin'],
      'answerIndex': 2,
    },
    {
      'question': 'Which widget is immutable?',
      'options': ['StatelessWidget', 'StatefulWidget', 'TextField', 'Column'],
      'answerIndex': 0,
    },
    {
      'question': 'What is setState used for?',
      'options': [
        'Updating the state',
        'Rendering images',
        'Making API calls',
        'Handling navigation'
      ],
      'answerIndex': 0,
    },
    {
      'question': 'Which is a layout widget?',
      'options': ['Column', 'Http', 'Route', 'SnackBar'],
      'answerIndex': 0,
    },
  ];

  void _handleAnswer(int selectedIndex) {
    final isCorrect = selectedIndex == questions[currentQuestionIndex]['answerIndex'];

    if (isCorrect) correctAnswers++;
    userSelections.add(selectedIndex);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {
          'total': questions.length,
          'correct': correctAnswers,
          'selections': userSelections,
          'questions': questions,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              question['question'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(index),
                  child: Text(question['options'][index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
