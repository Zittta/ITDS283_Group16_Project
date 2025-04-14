import 'dart:math';
import 'package:flutter/material.dart';
import 'result.dart';
import '../database/database_helper.dart';

class QuizzingPage extends StatefulWidget {
  final int folderId;

  const QuizzingPage({super.key, required this.folderId});

  @override
  State<QuizzingPage> createState() => _QuizzingPageState();
}

class _QuizzingPageState extends State<QuizzingPage> {
  List<Map<String, dynamic>> cards = [];
  List<Map<String, dynamic>> questions = [];

  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  List<int> userSelections = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final allCards = await DatabaseHelper().getCards(widget.folderId);
    if (allCards.length < 5) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Shuffle and generate questions with 5 choices each
    final random = Random();
    for (var card in allCards) {
      final correctMeaning = card['meaning'];
      final questionText = card['question'];

      // Get 4 incorrect meanings
      final incorrectOptions = allCards
          .where((c) => c['id'] != card['id'] && c['meaning'] != correctMeaning)
          .map((c) => c['meaning'] as String)
          .toList();

      incorrectOptions.shuffle(random);
      final choices = incorrectOptions.take(4).toList();
      choices.add(correctMeaning);
      choices.shuffle(random);

      final answerIndex = choices.indexOf(correctMeaning);

      questions.add({
        'question': questionText,
        'options': choices,
        'answerIndex': answerIndex,
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handleAnswer(int selectedIndex) async {
  final isCorrect = selectedIndex == questions[currentQuestionIndex]['answerIndex'];
  if (isCorrect) correctAnswers++;
  userSelections.add(selectedIndex);

  if (currentQuestionIndex < questions.length - 1) {
    setState(() {
      currentQuestionIndex++;
    });
  } else {
    // Insert score before navigating
    await DatabaseHelper().insertQuizScore(widget.folderId, correctAnswers);

    // Navigate to results
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(
          folderId: widget.folderId,
          correct: correctAnswers,
          total: questions.length,
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Not enough cards to generate quiz.')),
      );
    }

    final question = questions[currentQuestionIndex];
    final options = question['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(options.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(index),
                  child: Text(options[index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
