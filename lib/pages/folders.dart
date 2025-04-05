import 'package:flutter/material.dart';
import 'card_set.dart'; // Adjust the path if it's in a subfolder


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
                Text(
                  "Creating Options",
                  style: theme.textTheme.titleMedium,
                ),
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

  void _showChangeFolderNameDialog(int index) {
    _controller.text = folders[index];
    showDialog(
      context: context,
      builder: (context) => _buildChangeFolderNameDialog(index),
    );
  }

  Widget _buildChangeFolderNameDialog(int index) {
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  setState(() {
                    folders[index] = _controller.text.trim();
                    _controller.clear();
                  });
                  Navigator.of(context).pop();
                },
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Flash Cards',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.folder, size: 28, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  'Folders',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: folders.isEmpty
                  ? _buildEmptyMessage(theme)
                  : _buildFolderList(theme),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateFolderDialog,
        backgroundColor: theme.colorScheme.primaryContainer,
        icon: Icon(Icons.add, color: theme.iconTheme.color),
        label: Text(
          'New Folder',
          style: theme.textTheme.labelLarge,
        ),
      ),
    );
  }

  Widget _buildEmptyMessage(ThemeData theme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "There are no folders to display.\nPlease press 'New Folder' to create a folder",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildFolderList(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.folder, color: theme.iconTheme.color),
            title: Text(folders[index], style: theme.textTheme.bodyLarge),
            onTap: () {
              // Navigate to CardSet on folder icon/title tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CardSet(),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.quiz, color: theme.iconTheme.color),
                  onPressed: () {
                    // Navigate to the '/quiz' page when the quiz icon is pressed
                    Navigator.pushNamed(context, '/quiz');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
                  onPressed: () {
                    _showChangeFolderNameDialog(index);
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
