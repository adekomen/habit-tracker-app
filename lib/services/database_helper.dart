import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        evaluationType TEXT NOT NULL,
        frequency TEXT NOT NULL,
        startDate TEXT NOT NULL,
        targetDate TEXT,
        reminderTime TEXT,
        priority TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        progress INTEGER NOT NULL,
        completedDates TEXT
      )
    ''');
  }

  // Ajouter une habitude
  Future<int> insertHabit(Habit habit) async {
    Database db = await database;
    return await db.insert('habits', habit.toMap());
  }

  // Récupérer toutes les habitudes
  Future<List<Habit>> getHabits() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  // Mettre à jour une habitude
  Future<int> updateHabit(Habit habit) async {
    Database db = await database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // Supprimer une habitude
  Future<int> deleteHabit(String id) async {
    Database db = await database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}