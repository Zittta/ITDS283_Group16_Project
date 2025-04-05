import 'package:flutter/material.dart';
class CardSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Folder name')),
      body: Center(child: Text('Card set', style: TextStyle(fontSize: 24))),
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