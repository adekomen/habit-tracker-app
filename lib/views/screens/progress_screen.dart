import 'package:flutter/material.dart';
import '../../widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressData = {
      DateTime(2023, 10, 1): 5,
      DateTime(2023, 10, 2): 7,
      DateTime(2023, 10, 3): 3,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progrès'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressChart(progressData: progressData),
      ),
    );
  }
}