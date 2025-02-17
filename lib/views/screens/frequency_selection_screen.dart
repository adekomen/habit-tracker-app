import 'package:flutter/material.dart';
import 'date_and_reminder_screen.dart';
import '../../models/category.dart';

class FrequencySelectionScreen extends StatelessWidget {
  final String name;
  final String description;
  final Category selectedCategory;
  final String evaluationType;

  const FrequencySelectionScreen({
    super.key,
    required this.name,
    required this.description,
    required this.selectedCategory,
    required this.evaluationType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fréquence'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sélectionnez la fréquence de votre habitude'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateAndReminderScreen(
                      name: name,
                      description: description,
                      selectedCategory: selectedCategory,
                      evaluationType: evaluationType,
                      frequency: 'Quotidienne', // Exemple de fréquence
                    ),
                  ),
                );
              },
              child: const Text('Quotidienne'),
            ),
          ],
        ),
      ),
    );
  }
}