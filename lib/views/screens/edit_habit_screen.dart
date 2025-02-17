import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({super.key, required this.habit});

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController = TextEditingController(text: widget.habit.description);
  }

  @override
  Widget build(BuildContext context) {
    final habitController = Provider.of<HabitController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'habitude'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom de l\'habitude'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedHabit = Habit(
                  id: widget.habit.id,
                  name: _nameController.text,
                  description: _descriptionController.text,
                  category: widget.habit.category,
                  evaluationType: widget.habit.evaluationType,
                  frequency: widget.habit.frequency,
                  startDate: widget.habit.startDate,
                  targetDate: widget.habit.targetDate,
                  reminderTime: widget.habit.reminderTime,
                  priority: widget.habit.priority,
                  isCompleted: widget.habit.isCompleted,
                  progress: widget.habit.progress,
                  completedDates: widget.habit.completedDates,
                );

                try {
                  await habitController.updateHabit(updatedHabit);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Habitude "${updatedHabit.name}" mise à jour avec succès.')),
                  );
                  Navigator.pop(context); // Retour à l'écran précédent
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
                  );
                }
              },
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}