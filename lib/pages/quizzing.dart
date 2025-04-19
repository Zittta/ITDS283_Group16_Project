import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'result.dart';
import '../database/database_helper.dart';

class QuizzingPage extends StatefulWidget {
  final int folderId;
  final String selectedQuestionType;
  final int totalQuestions;

  const QuizzingPage({
    super.key,
    required this.folderId,
    required this.selectedQuestionType,
    required this.totalQuestions,
  });

  @override
  State<QuizzingPage> createState() => _QuizzingPageState();
}

class _QuizzingPageState extends State<QuizzingPage> {
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
    final allCards = List<Map<String, dynamic>>.from(await DatabaseHelper().getCards(widget.folderId));

    if (allCards.length < widget.totalQuestions) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final random = Random();
    allCards.shuffle(random);
    final selectedCards = allCards.take(widget.totalQuestions).toList();

    for (var card in selectedCards) {
      final correctMeaning = card['meaning'];
      final correctQuestion = card['question'];
      final cardImage = card['photo'];

      if (widget.selectedQuestionType == "Front") {
        // FRONT: Show the question, options are meanings
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
          'question': correctQuestion,
          'options': choices,
          'answerIndex': answerIndex,
          'image': cardImage,
        });
      } else {
        // BACK: Show the meaning, options are questions
        final incorrectQuestions = allCards
            .where((c) => c['id'] != card['id'] && c['question'] != correctQuestion)
            .map((c) => c['question'] as String)
            .toList();

        incorrectQuestions.shuffle(random);
        final choices = incorrectQuestions.take(4).toList();
        choices.add(correctQuestion);
        choices.shuffle(random);

        final answerIndex = choices.indexOf(correctQuestion);

        questions.add({
          'question': correctMeaning,
          'options': choices,
          'answerIndex': answerIndex,
          'image': cardImage,
        });
      }
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
      await DatabaseHelper().insertQuizScore(widget.folderId, correctAnswers);

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
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text('Not enough cards to generate quiz.'),
        ),
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

            // Show image if available
            if (question['image'] != null && question['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.file(
                  File(question['image']),
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),

            // Centered question
            Center(
              child: Text(
                question['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // Multiple choice options
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
