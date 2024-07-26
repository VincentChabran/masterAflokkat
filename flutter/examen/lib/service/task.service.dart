// ignore_for_file: avoid_print

import 'package:examen/models/task.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskService {
  static const String _dbName = "examen.db";
  static const String _tableName = "task";

  static Future<Task> createTask(String nom, String description) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
    );

    final id = await db.insert(
      _tableName,
      {"nom": nom, "description": description, "isCompleted": 0},
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    return Task(id: id, nom: nom, description: description, isCompleted: false);
  }

  static Future<List<Task>> getAllTask() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
    );

    final List<Map<String, Object?>> taskMap = await db.query(_tableName);

    return [
      for (final {
            'id': id as int,
            'nom': nom as String,
            'description': description as String,
            'isCompleted': isCompleted as int,
          } in taskMap)
        Task(id: id, nom: nom, description: description, isCompleted: isCompleted == 1 ? true : false),
    ];
  }

  static Future<Task> updateTask(int id, String nom, String description, bool isCompleted) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
    );

    await db.update(
      _tableName,
      {'nom': nom, 'description': description, 'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    return Task(id: id, nom: nom, description: description, isCompleted: isCompleted);
  }

  static Future<void> updateIsCompletedFromTask(int id, bool isCompleted) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
    );

    await db.update(
      _tableName,
      {'isCompleted': isCompleted ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    return;
  }

  static Future<String> deleteTask(String id) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
    );

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return "Tâche $id supprimée avec succès.";
  }
}
