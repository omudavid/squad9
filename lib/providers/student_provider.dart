import 'package:flutter/cupertino.dart';
import 'package:week12/database_provider.dart';

class StudentProvider extends ChangeNotifier {
  StudentProvider() {
    initializeList();
    print('i have been created');
  }

  final List<Student> _list = [];

  List<Student> get list => _list;

  Future<void> initializeList() async {
    final students = await DBProvider.db.getStudents();
    _list.addAll(students);
    notifyListeners();
  }

  void addToList() {
    _list.add(Student(5, 'Abike', 25));
    notifyListeners();
  }
}
