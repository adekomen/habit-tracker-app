import 'package:flutter/material.dart';
import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final DateTime date; // Ajouter une date
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.date, // Passer la date en paramètre
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.completedDates.contains(date); // Vérifier si l'habitude est terminée pour cette date

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          Icons.check_circle,
          color: isCompleted ? Colors.green : Colors.grey, // Utiliser isCompleted au lieu de habit.isCompleted
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null, // Utiliser isCompleted
          ),
        ),
        subtitle: Text(
          habit.category,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Action pour afficher plus d'options (modifier, supprimer, etc.)
          },
        ),
        onTap: onTap, // Marquer l'habitude comme terminée ou non pour cette date
      ),
    );
  }
}