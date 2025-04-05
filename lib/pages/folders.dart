import 'package:flutter/material.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  final TextEditingController _controller = TextEditingController();
  final List<String> folders = [];

  void _addFolder(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      folders.add(name.trim());
      _controller.clear();
    });
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildCreateFolderDialog(),
    );
  }

  Widget _buildCreateFolderDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Creating Options",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Label
            const Text(
              "Folder name",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // TextField
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter folder name',
              ),
            ),
            const SizedBox(height: 20),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _addFolder(_controller.text);
                  Navigator.of(context).pop(); // Close dialog after creation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeFolderNameDialog(int index) {
    _controller.text = folders[index]; // Pre-fill with current folder name
    showDialog(
      context: context,
      builder: (context) => _buildChangeFolderNameDialog(index),
    );
  }

  Widget _buildChangeFolderNameDialog(int index) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Close Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Change Folder Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Label
            const Text(
              "New folder name",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // TextField
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new folder name',
              ),
            ),
            const SizedBox(height: 20),

            // Change Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  setState(() {
                    folders[index] = _controller.text.trim();
                    _controller.clear();
                  });
                  Navigator.of(context).pop(); // Close dialog after change
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Change"),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: folders.isEmpty
                  ? _buildEmptyMessage()
                  : _buildFolderList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateFolderDialog,
        backgroundColor: Colors.grey[300],
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'New Folder',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
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
    );
  }

  Widget _buildFolderList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.folder, color: Colors.grey),
            title: Text(folders[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.quiz, color: Colors.black),
                  onPressed: () {
                    // TODO: handle quiz action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {
                    _showChangeFolderNameDialog(index); // Open change folder dialog
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
