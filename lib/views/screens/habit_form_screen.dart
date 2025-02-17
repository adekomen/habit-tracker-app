import 'package:flutter/material.dart';
import 'frequency_selection_screen.dart';
import '../../models/category.dart';

class HabitFormScreen extends StatelessWidget {
  final Category selectedCategory;
  final String evaluationType;

  const HabitFormScreen({
    super.key,
    required this.selectedCategory,
    required this.evaluationType,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Définissez votre habitude'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Habitude',
                hintText: 'par exemple, « Appeler un ami »',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (en option)',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Retour à l'écran précédent
              },
              child: const Text('PRÉCÉDENT'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FrequencySelectionScreen(
                      name: nameController.text,
                      description: descriptionController.text,
                      selectedCategory: selectedCategory,
                      evaluationType: evaluationType,
                    ),
                  ),
                );
              },
              child: const Text('SUIVANT'),
            ),
          ],
        ),
      ),
    );
  }
}