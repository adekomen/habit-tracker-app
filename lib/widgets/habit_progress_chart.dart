import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HabitProgressChart extends StatelessWidget {
  final List<int> weeklyProgress; // Liste des progrès (ex: [3, 5, 2, 4, 6, 7, 1])

  const HabitProgressChart({super.key, required this.weeklyProgress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: _buildBars(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    return List.generate(weeklyProgress.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyProgress[index].toDouble(),
            color: Colors.blueAccent,
            width: 16,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }
}
