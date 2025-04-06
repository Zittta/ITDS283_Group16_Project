import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final int correct = args['correct'];
    final int total = args['total'];

    final dataMap = {
      "Correct": correct.toDouble(),
      "Wrong": (total - correct).toDouble(),
    };

    return Scaffold(
      appBar: AppBar(title: Text("Your Results")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Quiz Completed!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            PieChart(
              dataMap: dataMap,
              chartRadius: 150,
              legendOptions: LegendOptions(
                legendPosition: LegendPosition.bottom,
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "You got $correct out of $total correct!",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text("Back to Start"),
            ),
          ],
        ),
      ),
    );
  }
}
