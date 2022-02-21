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

      db.execute('''
      CREATE TABLE teachers (
      id INTEGER PRIMARY KEY,
      name TEXT,
      age INTEGER
      )
      ''');
    }, onDowngrade: (db, oldVersion, newVersion) async {
      ///Called when version of an incoming or update is lower than the current version number
    }, onUpgrade: (db, oldVersion, newVersion) async {
      ///Called when version of an incoming or update is higher than the current version number
      if (oldVersion == 1) {
        upgradeToVersion2(db);
      }
    }, version: 2);
  }

  Future<void> upgradeToVersion2(Database db) async {
    db.execute('''
      CREATE TABLE teachers (
      id INTEGER PRIMARY KEY,
      name TEXT,
      age INTEGER
      )
      ''');
  }

  Future<int> newStudent(Student student) async {
    final db = await database;
    var res = await db?.insert('students', student.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return res ?? 1;
  }

  Future<void> editName(String name, int id) async {
    final db = await database;
    final res = await db?.update('students', {'name': name, 'age': 24},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db?.delete(
      'students',
    );
  }

  Future<int> newTeacher(Teacher teacher) async {
    final db = await database;
    var res = await db?.insert('teachers', teacher.toJson(),
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

  Future<List<Teacher>> getTeachers() async {
    final db = await database;
    final res = await db?.query('teachers');
    if (res?.isEmpty ?? true) {
      return [];
    } else {
      return res!.map((e) => Teacher.fromJson(e)).toList();
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

class Teacher {
  final int id;
  final String name;
  final int age;

  Teacher(this.id, this.name, this.age);

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age};
  }

  Teacher.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        age = json['age'];
}
