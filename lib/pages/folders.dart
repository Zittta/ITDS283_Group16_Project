import 'package:flutter/material.dart';

class Folders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('cardset'),
              onTap: (){
                //Task03: using Navigator.pushNamed
                Navigator.pushNamed(context, '/cardset');
              },
            ),
            ListTile(
              title: Text('quiz'),
              onTap: (){
                Navigator.pushNamed(context, '/quiz');
              },
            ),
            ListTile(
              title: Text('setting'),
              onTap: (){
                Navigator.pushNamed(context, '/setting');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Welcome to Home Page', style: TextStyle(fontSize: 24))),
    );
  }
}