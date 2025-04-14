import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../database/database_helper.dart';
import 'quiz.dart';

class ResultsPage extends StatefulWidget {
  final int folderId;
  final int correct;
  final int total;

  const ResultsPage({
    super.key,
    required this.folderId,
    required this.correct,
    required this.total,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> scoreHistory = [];
  String folderName = "";  // This will store the folder name

  @override
  void initState() {
    super.initState();
    _loadScores();
    _loadFolderName();
  }

  // Fetch the folder name from the database using folderId
  Future<void> _loadFolderName() async {
    final folders = await DatabaseHelper().getFolders();
    final folder = folders.firstWhere((folder) => folder['id'] == widget.folderId, orElse: () => {});
    setState(() {
      folderName = folder['name'] ?? "Unknown Folder"; // Set folder name or fallback
    });
  }

  Future<void> _loadScores() async {
    final scores = await DatabaseHelper().getQuizScores(widget.folderId);
    setState(() {
      scoreHistory = scores;
    });
  }

  String formatDateTime(String timestamp) {
    final dt = DateTime.parse(timestamp);
    final date = '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    return '$date||$time';
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.correct;
    final total = widget.total;

    final dataMap = {
      "Correct": correct.toDouble(),
      "Wrong": (total - correct).toDouble(),
    };

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Results"),
        elevation: 0, // No elevation for a flat app bar
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Quiz(
                    folderId: widget.folderId,
                    folderName: folderName,  // Use the fetched folder name
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Quiz Completed!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PieChart(
                dataMap: dataMap,
                chartRadius: 150,
                colorList: [colorScheme.primary, colorScheme.error],  // Fixed the error color usage here
                legendOptions: const LegendOptions(legendPosition: LegendPosition.bottom),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "You got $correct out of $total correct!",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                "History Score",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Scrollable score history only
              Expanded(
                child: ListView.builder(
                  itemCount: scoreHistory.length,
                  itemBuilder: (context, index) {
                    final row = scoreHistory[index];
                    final formatted = formatDateTime(row['timestamp']);
                    final parts = formatted.split("||");
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(parts[0],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(parts[1], style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Score: ${row['score']}",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Quiz(
                        folderId: widget.folderId,
                        folderName: folderName,  // Use the fetched folder name
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2, // Light elevation for button
                ),
                child: const Text("Back to Start"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
