import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week12/database_provider.dart';
import 'package:week12/model/PokemonResponse.dart';
import 'package:week12/providers/student_provider.dart';
import 'package:week12/providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final numbers = <int>[];
  int? count;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Consumer<StudentProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Text(value.list.toString());
              },
            ),
            TextButton(
                onPressed: () {
                  Provider.of<StudentProvider>(context, listen: false)
                      .addToList();
                },
                child: Text('tap')),
            TextButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeToDark();
                },
                child: Text('Dark')),
            TextButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeToLight();
                },
                child: Text('Light'))
          ],
        ));
  }

  Future<void> addTeacher() async {
    final teacher = Teacher(1, 'David', 30);
    DBProvider.db.newTeacher(teacher);
  }

  Future<void> getTeachers() async {
    final teachers = await DBProvider.db.getTeachers();
    for (var teacher in teachers) {
      print(teacher.toJson());
    }
  }

  Future<void> testSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setString('NAME', 'Kevin');
    final name = prefs.getString('NAME');

    print('This is name  $name');
    DBProvider.db;
  }

  Future<void> addStudent() async {
    final student = Student(3, 'Dele', 77);

    DBProvider.db.newStudent(student);
  }

  Future<void> getStudents() async {
    final students = await DBProvider.db.getStudents();
    for (var student in students) {
      print(student.toJson());
    }
  }

  Future<void> getPokemonsWithHttp() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon');
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    final pokemonResponse = PokemonResponse.fromJson(json);
    print(pokemonResponse);
  }

  Future<void> getPokemonsWithDio() async {
    final dio = Dio();
    await dio.get('https://pokeapi.co/api/v2/pokemon').then((response) {
      final pokemonResponse = PokemonResponse.fromJson(response.data);
      setState(() {
        count = pokemonResponse.count;
      });
    }).catchError((e) {
      print('Something went wrong $e ');
    });
  }

  Future<List<int>> getNumbers() async {
    await Future.delayed(Duration(seconds: 10));
    return [1, 2, 3, 3, 4, 4, 4];
  }

  Stream<int> numberStream() async* {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(seconds: 3));
      yield i;
    }
  }
}
