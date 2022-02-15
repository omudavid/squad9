import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  ///Private constructor
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    var dir = await getDatabasesPath();
    String newPath = join(dir, 'squad9.db');

    if (await Directory(dirname(newPath)).exists()) {
      ///No issues
    } else {
      try {
        await Directory(dirname(newPath)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }

    return await openDatabase(newPath, onCreate: (db, version) async {
      db.execute('''
      CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      age INTEGER
      )
      ''');
    },
        onDowngrade: (db, oldVersion, newVersion) async {},
        onUpgrade: (db, oldVersion, newVersion) async {},
        version: 1);
  }

  Future<int> newStudent(Student student) async {
    final db = await database;
    var res = await db?.insert('students', student.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res ?? 1;
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final res = await db?.query('students');
    if (res?.isEmpty ?? true) {
      return [];
    } else {
      return res!.map((e) => Student.fromJson(e)).toList();
    }
  }
}

class Student {
  final int id;
  final String name;
  final int age;

  Student(this.id, this.name, this.age);

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age};
  }

  Student.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        age = json['age'];
}
