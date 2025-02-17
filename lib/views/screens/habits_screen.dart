import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import 'edit_habit_screen.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitController = Provider.of<HabitController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitudes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Naviguer vers l'écran de création d'habitude
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: habitController.getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune habitude trouvée.'));
          } else {
            final habits = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return _buildHabitCard(context, habit);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    final habitController = Provider.of<HabitController>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: double.infinity, // Prendre toute la largeur disponible
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.pink,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _navigateToEditHabitScreen(context, habit);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteHabit(context, habitController, habit);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              habit.frequency,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressBar(habit.progress),
            const SizedBox(height: 8),
            Text(
              '${habit.progress}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCalendarRow(context, habit),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    return LinearProgressIndicator(
      value: progress / 100,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
    );
  }

  Widget _buildCalendarRow(BuildContext context, Habit habit) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final daysInWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: daysInWeek.map((date) {
        return _buildCalendarDay(context, habit, date);
      }).toList(),
    );
  }

  Widget _buildCalendarDay(BuildContext context, Habit habit, DateTime date) {
    final habitController = Provider.of<HabitController>(context, listen: false);
    final isCompleted = habit.completedDates.contains(date);
    final isToday = habitController.isSameDay(date, DateTime.now());

    return GestureDetector(
      onTap: () {
        habitController.toggleHabitCompletion(habit, date);
      },
      child: Column(
        children: [
          Text(
            _getDayName(date.weekday),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.pink.withOpacity(0.3)
                  : isToday
                  ? Colors.pink.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(color: Colors.pink, width: 2)
                  : null,
            ),
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.pink : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mer';
      case 4:
        return 'Jeu';
      case 5:
        return 'Ven';
      case 6:
        return 'Sam';
      case 7:
        return 'Dim';
      default:
        return '';
    }
  }

  void _navigateToEditHabitScreen(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHabitScreen(habit: habit),
      ),
    );
  }

  void _deleteHabit(BuildContext context, HabitController habitController, Habit habit) async {
    try {
      await habitController.removeHabit(habit.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habitude "${habit.name}" supprimée avec succès.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression : $e')),
      );
    }
  }
}