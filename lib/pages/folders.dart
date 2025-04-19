import 'package:flutter/material.dart';
import 'card_set.dart';
import 'quiz.dart';
import '../database/database_helper.dart'; // Adjust path as needed

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final data = await DatabaseHelper().getFolders();
    setState(() {
      folders = data;
    });
  }

  Future<void> _addFolder(String name) async {
    if (name.trim().isEmpty) return;
    await DatabaseHelper().insertFolder(name.trim());
    _controller.clear();
    _loadFolders();
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildCreateFolderDialog(),
    );
  }

  Widget _buildCreateFolderDialog() {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Creating Options", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: Icon(Icons.close, color: theme.iconTheme.color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Folder name", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter folder name',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _addFolder(_controller.text);
                  Navigator.of(context).pop();
                },
                child: const Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeFolderNameDialog(Map<String, dynamic> folder) {
    _controller.text = folder['name'];
    showDialog(
      context: context,
      builder: (context) => _buildChangeFolderNameDialog(folder),
    );
  }

  Widget _buildChangeFolderNameDialog(Map<String, dynamic> folder) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Change Folder Name", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: Icon(Icons.close, color: theme.iconTheme.color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("New folder name", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new folder name',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_controller.text.trim().isEmpty) return;
                      await DatabaseHelper().updateFolder(
                        folder['id'],
                        _controller.text.trim(),
                      );
                      _controller.clear();
                      Navigator.of(context).pop();
                      _loadFolders();
                    },
                    child: const Text("Change"),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.colorScheme.error),
                  tooltip: "Delete Folder",
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Folder"),
                        content: const Text(
                          "Are you sure you want to delete this folder? This will also delete all associated cards and scores.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              "Delete",
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      await DatabaseHelper().deleteFolder(folder['id']);
                      Navigator.of(context).pop();
                      _loadFolders();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'FlashZzCards',
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 12),
          Text(
            'Folders',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // New Folder Card - With the same container style as folder cards
                InkWell(
                  onTap: _showCreateFolderDialog,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Icon(Icons.add, size: 32, color: theme.iconTheme.color),
                              const SizedBox(height: 8),
                              Text('New Folder', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Display folders
                ...folders.map((folder) => _buildFolderCard(theme, folder)).toList(),
                if (folders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Center(
                      child: Text(
                        "There are no folders to display.\nPlease press 'New Folder' to create a folder",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderCard(ThemeData theme, Map<String, dynamic> folder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardSet(
                          folderId: folder['id'],
                          folderName: folder['name'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    folder['name'],
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
                onPressed: () => _showChangeFolderNameDialog(folder),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Quiz(
                    folderId: folder['id'],
                    folderName: folder['name'],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.quiz_outlined),
            label: const Text('Start Quiz'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}