import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryController with ChangeNotifier {
  List<Category> customCategories = [];
  List<Category> defaultCategories = [
    Category(name: 'Quitter une habitude', icon: Icons.exit_to_app, color: Colors.red),
    Category(name: 'Art', icon: Icons.brush, color: Colors.blue),
    Category(name: 'Méditation', icon: Icons.self_improvement, color: Colors.purple),
    Category(name: 'Études', icon: Icons.school, color: Colors.orange),
    Category(name: 'Sports', icon: Icons.sports, color: Colors.teal),
    Category(name: 'Divertissement', icon: Icons.movie, color: Colors.pink),
    Category(name: 'Social', icon: Icons.people, color: Colors.indigo),
    Category(name: 'Finances', icon: Icons.attach_money, color: Colors.green),
    Category(name: 'Santé', icon: Icons.health_and_safety, color: Colors.lightGreen),
    Category(name: 'Travail', icon: Icons.work, color: Colors.blueGrey),
    Category(name: 'Alimentation', icon: Icons.fastfood, color: Colors.brown),
    Category(name: 'Maison', icon: Icons.home, color: Colors.amber),
    Category(name: 'Extérieur', icon: Icons.nature, color: Colors.lightBlue),
    Category(name: 'Autre', icon: Icons.category, color: Colors.grey),
  ];

  void addCategory(Category category) {
    customCategories.add(category);
    notifyListeners();
  }
}