import 'package:flutter/material.dart';
class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Center(child: Text('Setting', style: TextStyle(fontSize: 24))),
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