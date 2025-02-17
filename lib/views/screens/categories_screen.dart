import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/category_controller.dart';
import '../../models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = context.watch<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Catégories personnalisées',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${categoryController.customCategories.length} disponibles',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (categoryController.customCategories.isEmpty)
              const Center(
                child: Text('Il n\'existe aucune catégorie personnalisée'),
              ),
            ...categoryController.customCategories.map((category) {
              return ListTile(
                leading: Icon(category.icon, color: category.color),
                title: Text(category.name),
                trailing: Text('${category.entries} saisies'),
              );
            }).toList(),
            const SizedBox(height: 24),
            const Text(
              'Catégories par défaut',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Modifiable pour les utilisateurs premium',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...categoryController.defaultCategories.map((category) {
              return ListTile(
                leading: Icon(category.icon, color: category.color),
                title: Text(category.name),
                trailing: Text('${category.entries} saisies'),
              );
            }).toList(),
            const SizedBox(height: 80), // Espace pour éviter que le contenu ne soit caché par le bouton
          ],
        ),
      ),
      // Bouton en bas de l'écran
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              _showAddCategoryDialog(context);
            },
            child: const Text('NOUVELLE CATÉGORIE'),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final categoryController = Provider.of<CategoryController>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    IconData selectedIcon = Icons.category; // Icône par défaut
    Color selectedColor = Colors.blue; // Couleur par défaut

    // Liste des icônes disponibles
    final List<IconData> icons = [
      Icons.category,
      Icons.work,
      Icons.school,
      Icons.self_improvement,
      Icons.brush,
      Icons.sports,
      Icons.movie,
      Icons.people,
      Icons.attach_money,
      Icons.health_and_safety,
      Icons.fastfood,
      Icons.home,
      Icons.nature,
    ];

    // Liste des couleurs disponibles
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.lightGreen,
      Colors.blueGrey,
      Colors.brown,
      Colors.amber,
      Colors.lightBlue,
      Colors.grey,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Créer une catégorie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ de texte pour le nom de la catégorie
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la catégorie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Sélection d'icône
                const Text(
                  'Icône de la catégorie',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150, // Limitez la hauteur de la grille d'icônes
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // 5 icônes par ligne
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          selectedIcon = icons[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIcon == icons[index]
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icons[index],
                            color: selectedIcon == icons[index]
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Sélection de couleur
                const Text(
                  'Couleur de la catégorie',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150, // Limitez la hauteur de la grille de couleurs
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // 5 couleurs par ligne
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          selectedColor = colors[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors[index],
                            borderRadius: BorderRadius.circular(8),
                            border: selectedColor == colors[index]
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child: const Text('FERMER'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final newCategory = Category(
                    name: nameController.text,
                    icon: selectedIcon,
                    color: selectedColor,
                  );
                  categoryController.addCategory(newCategory);
                  Navigator.pop(context);
                }
              },
              child: const Text('CRÉER UNE CATÉGORIE'),
            ),
          ],
        );
      },
    );
  }
}