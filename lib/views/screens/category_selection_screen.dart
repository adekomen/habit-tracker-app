import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/category_controller.dart';
import '../../models/category.dart';
import 'evaluation_type_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = context.watch<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une catégorie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...categoryController.defaultCategories.map((category) {
              return ListTile(
                leading: Icon(category.icon, color: category.color),
                title: Text(category.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvaluationTypeScreen(
                        selectedCategory: category, // Passer la catégorie sélectionnée
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              // Naviguer vers l'écran de création de catégorie
            },
            child: const Text('CRÉER UNE CATÉGORIE'),
          ),
        ),
      ),
    );
  }
}