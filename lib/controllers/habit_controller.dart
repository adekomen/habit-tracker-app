import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_helper.dart'; // Importez DatabaseHelper

class HabitController with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Ajouter une habitude
  Future<void> addHabit(Habit habit) async {
    await _databaseHelper.insertHabit(habit);
    notifyListeners();
  }

  // Supprimer une habitude
  Future<void> removeHabit(String habitId) async {
    await _databaseHelper.deleteHabit(habitId);
    notifyListeners();
  }

  // Mettre à jour une habitude
  Future<void> updateHabit(Habit habit) async {
    await _databaseHelper.updateHabit(habit);
    notifyListeners();
  }

  // Récupérer toutes les habitudes
  Future<List<Habit>> getHabits() async {
    return await _databaseHelper.getHabits();
  }

  // Récupérer les habitudes pour un jour spécifique
  Future<List<Habit>> getHabitsForDay(DateTime date) async {
    final habits = await _databaseHelper.getHabits();
    return habits.where((habit) => isSameDay(habit.startDate, date)).toList();
  }

  // Vérifier si deux dates sont identiques (même jour)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Basculer l'état de complétion d'une habitude pour une date donnée
  Future<void> toggleHabitCompletion(Habit habit, DateTime date) async {
    if (habit.completedDates.contains(date)) {
      habit.completedDates.remove(date);
    } else {
      habit.completedDates.add(date);
    }
    // Recalculer le pourcentage de progression
    habit.progress = (habit.completedDates.length / 7 * 100).round(); // Exemple pour une semaine
    await _databaseHelper.updateHabit(habit);
    notifyListeners();
  }
}