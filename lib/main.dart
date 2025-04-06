import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/folders.dart';
import 'pages/card_set.dart';
import 'pages/quiz.dart';
import 'pages/quizzing.dart';
import 'pages/setting.dart';
import 'pages/add_edit_card.dart';
import 'pages/result.dart';
import 'theme/theme_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flashcard App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: Folders(),
            routes: {
              '/cardset': (context) => CardSet(),
              '/quiz': (context) => Quiz(),
              '/setting': (context) => Setting(),
              '/add_card': (context) => AddEditCard(),
              '/quizzing': (context) => QuizzingPage(),
              '/results': (context) => ResultsPage(),
            },
          );
        },
      ),
    );
  }
}
