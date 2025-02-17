import 'package:flutter/material.dart';
import 'habit_form_screen.dart';
import '../../models/category.dart';

class EvaluationTypeScreen extends StatelessWidget {
  final Category selectedCategory;

  const EvaluationTypeScreen({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Évaluer vos progrès'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('AVEC OUI OU NON'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitFormScreen(
                      selectedCategory: selectedCategory,
                      evaluationType: 'Oui/Non',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('AVEC UNE VALEUR NUMÉRIQUE'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitFormScreen(
                      selectedCategory: selectedCategory,
                      evaluationType: 'Valeur numérique',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('AVEC UN CHRONOMÈTRE'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitFormScreen(
                      selectedCategory: selectedCategory,
                      evaluationType: 'Chronomètre',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('AVEC UNE LISTE D\'ACTIVITÉS'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitFormScreen(
                      selectedCategory: selectedCategory,
                      evaluationType: 'Liste d\'activités',
                    ),
                  ),
                );
              },
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
          ],
        ),
      ),
    );
  }
}