import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/notification_service.dart';
import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../models/category.dart';
import 'home_screen.dart';
import '../../services/database_helper.dart';

class DateAndReminderScreen extends StatefulWidget {
  final String name;
  final String description;
  final Category selectedCategory;
  final String evaluationType;
  final String frequency;

  const DateAndReminderScreen({
    super.key,
    required this.name,
    required this.description,
    required this.selectedCategory,
    required this.evaluationType,
    required this.frequency,
  });

  @override
  _DateAndReminderScreenState createState() => _DateAndReminderScreenState();
}

class _DateAndReminderScreenState extends State<DateAndReminderScreen> {
  DateTime _startDate = DateTime.now();
  DateTime? _targetDate;
  TimeOfDay? _reminderTime;
  String _priority = 'Normal';

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectTargetDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dates et rappels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Nom de l\'habitude'),
              subtitle: Text(widget.name),
            ),
            ListTile(
              title: const Text('Description'),
              subtitle: Text(widget.description),
            ),
            ListTile(
              title: const Text('Date de début'),
              subtitle: Text('${_startDate.toLocal()}'.split(' ')[0]),
              onTap: () => _selectStartDate(context),
            ),
            ListTile(
              title: const Text('Date cible'),
              subtitle: Text(_targetDate == null ? 'Non défini' : '${_targetDate!.toLocal()}'.split(' ')[0]),
              onTap: () => _selectTargetDate(context),
            ),
            ListTile(
              title: const Text('Heure et rappels'),
              subtitle: Text(_reminderTime == null ? 'Non défini' : _reminderTime!.format(context)),
              onTap: () => _selectReminderTime(context),
            ),
            ListTile(
              title: const Text('Priorité'),
              subtitle: Text(_priority),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Choisir la priorité'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Normal'),
                            onTap: () {
                              setState(() {
                                _priority = 'Normal';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Élevée'),
                            onTap: () {
                              setState(() {
                                _priority = 'Élevée';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
            TextButton(
              onPressed: () async {
                try {
                  print('Création de l\'habitude...');
                  final habit = Habit(
                    id: DateTime.now().toString(),
                    name: widget.name,
                    description: widget.description,
                    category: widget.selectedCategory.name,
                    evaluationType: widget.evaluationType,
                    frequency: widget.frequency,
                    startDate: _startDate,
                    targetDate: _targetDate,
                    reminderTime: _reminderTime,
                    priority: _priority,
                  );

                  print('Insertion de l\'habitude dans la base de données...');
                  await DatabaseHelper().insertHabit(habit);

                  print('Planification de la notification...');
                  final notificationService = NotificationService();
                  await notificationService.init();

                  if (_reminderTime != null) {
                    final scheduledDate = DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      _reminderTime!.hour,
                      _reminderTime!.minute,
                    );

                    await notificationService.scheduleNotification(
                      id: habit.id.hashCode,
                      title: 'Rappel : ${habit.name}',
                      body: 'N\'oubliez pas de ${habit.name} !',
                      scheduledDate: scheduledDate,
                    );
                  }

                  print('Navigation vers l\'écran d\'accueil...');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false, // Supprime toutes les routes précédentes
                  );
                } catch (e) {
                  print('Erreur : $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
                  );
                }
              },
              child: const Text('ENREGISTRER'),
            ),
          ],
        ),
      ),
    );
  }
}