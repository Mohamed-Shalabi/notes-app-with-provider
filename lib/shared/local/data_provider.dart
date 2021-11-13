import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class NotesDataProvider {
  NotesDataProvider._();
  static late final sqflite.Database _database;
  static const _databaseName = 'tasks_database.db';
  static const _tableName = 'tasks_table';
  static const _databaseVersion = 2;
  static Future<void> openDatabase() async {
    try {
      _database = await sqflite.openDatabase(_databaseName, version: _databaseVersion, onCreate: (database, version) async {
        try {
          await database.execute(
            'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, '
            'text TEXT, '
            'creation_time STRING, '
            'modification_time STRING, '
            'end_time STRING, '
            'archived INTEGER, '
            'completed INTEGER, '
            'locked INTEGER, '
            'color INTEGER'
            ')',
          );
        } catch (e, s) {
          debugPrint(e.toString());
          debugPrint(s.toString());
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  static Future<int> insert(Map<String, dynamic> noteMapped) async {
    debugPrint('database inserted');
    return await _database.insert(_tableName, noteMapped);
  }

  static Future<int> delete(int id) async {
    debugPrint('database item deleted');
    return await _database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAll() async {
    debugPrint('database deleted');
    return await _database.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('database queried');
    return await _database.query(_tableName);
  }

  static Future<int> updateCompleted(int id, int completed) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET completed = ?
      WHERE id = ?''',
      [completed, id],
    );
  }

  static Future<int> updateArchived(int id, int archived) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET archived = ?
      WHERE id = ?''',
      [archived, id],
    );
  }

  static Future<int> updateLocked(int id, int locked) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET locked = ?
      WHERE id = ?''',
      [locked, id],
    );
  }

  static Future<int> updateColor(int id, int color) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET color = ?
      WHERE id = ?''',
      [color, id],
    );
  }

  static Future<int> updateModificationTime(int id, int modificationTime) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET modification_time = ?
      WHERE id = ?''',
      [modificationTime, id],
    );
  }

  static Future<int> updateTitle(int id, String title) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET title = ?
      WHERE id = ?''',
      [title, id],
    );
  }

  static Future<int> updateText(int id, String text) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET text = ?
      WHERE id = ?''',
      [text, id],
    );
  }
}
