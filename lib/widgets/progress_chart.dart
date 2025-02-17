import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressChart extends StatelessWidget {
  final Map<DateTime, int> progressData; // Données de progression (date -> valeur)

  const ProgressChart({super.key, required this.progressData});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = progressData.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key.day, // Utilisez le jour comme axe X
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(), // Valeur de progression
            color: Colors.pink,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}'); // Afficher le jour
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}'); // Afficher la valeur
              },
            ),
          ),
        ),
      ),
    );
  }
}