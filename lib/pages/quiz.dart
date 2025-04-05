import 'package:flutter/material.dart';
class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Center(child: Text('Quiz', style: TextStyle(fontSize: 24))),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //task04
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}