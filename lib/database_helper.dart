
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Todo {
  final int? id;
  final String title;
  final String content;
  final String date;

  Todo({this.id, required this.title, required this.content, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE todos ( 
  id $idType, 
  title $textType,
  content $textType,
  date $textType
  )
''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert('todos', todo.toMap());
    return Todo(id: id, title: todo.title, content: todo.content, date: todo.date);
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    final orderBy = 'id DESC';
    final result = await db.query('todos', orderBy: orderBy);

    return result.map((json) => Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    )).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
