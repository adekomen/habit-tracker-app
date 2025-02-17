import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final String category;
  final String evaluationType;
  final String frequency;
  final DateTime startDate;
  final DateTime? targetDate;
  final TimeOfDay? reminderTime;
  final String priority;
  bool isCompleted;
  int progress;
  final Set<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.evaluationType,
    required this.frequency,
    required this.startDate,
    this.targetDate,
    this.reminderTime,
    required this.priority,
    this.isCompleted = false,
    this.progress = 0,
    this.completedDates = const {},
  });

  // Convertir un Habit en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'evaluationType': evaluationType,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'reminderTime': reminderTime != null
          ? '${reminderTime!.hour}:${reminderTime!.minute}'
          : null,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'progress': progress,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList().join(','),
    };
  }

  // Convertir un Map en Habit
  factory Habit.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        print('Erreur de parsing de date: $dateString');
        return null;
      }
    }

    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      evaluationType: map['evaluationType'],
      frequency: map['frequency'],
      startDate: parseDate(map['startDate']) ?? DateTime.now(), // Utiliser une date par défaut en cas d'erreur
      targetDate: parseDate(map['targetDate']),
      reminderTime: map['reminderTime'] != null
          ? TimeOfDay(
        hour: int.parse(map['reminderTime'].split(':')[0]),
        minute: int.parse(map['reminderTime'].split(':')[1]),
      )
          : null,
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      progress: map['progress'],
      completedDates: map['completedDates'] != null
          ? (map['completedDates'] as String)
          .split(',')
          .map((date) => parseDate(date) ?? DateTime.now()) // Utiliser une date par défaut en cas d'erreur
          .toSet()
          : {},
    );
  }
}