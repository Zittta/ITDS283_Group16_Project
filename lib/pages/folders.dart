import 'package:flutter/material.dart';

class Folders extends StatelessWidget {
  const Folders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: const Text(
          'Flash Cards',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[400],
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                Icon(Icons.folder, size: 28, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Folders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "There are no folders to display.\nPlease press 'New Folder' to create a folder",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add folder creation logic
        },
        backgroundColor: Colors.grey[300],
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'New Folder',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
