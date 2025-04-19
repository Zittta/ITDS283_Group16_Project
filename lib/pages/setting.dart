import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Standalone Sun/Moon Icon Box
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => themeProvider.toggleTheme(!isDarkMode),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: Icon(Icons.wb_sunny, size: 64, color: Colors.orange.shade600),
                    secondChild: Icon(Icons.nightlight_round, size: 64, color: Colors.indigo.shade200),
                    crossFadeState: isDarkMode
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dark Mode Switch
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              subtitle: const Text("Toggle app theme"),
              value: isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(val),
            ),
          ),
          const SizedBox(height: 20),
          // About Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              subtitle: const Text("Version 1.0.0"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Flashcard App",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 YourName",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
