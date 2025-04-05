import 'package:flutter/material.dart';
import 'pages/card_set.dart';
import 'pages/folders.dart';
import 'pages/quiz.dart';
import 'pages/setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Folders(),
        '/cardset': (context) => CardSet(),
        '/quiz': (context) => Quiz(),
        '/setting': (context) => Setting(),
      },
    );
  }
}
