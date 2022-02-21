import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.system;

  void changeToLight() {
    currentTheme = ThemeMode.light;
    print('light');
    notifyListeners();
  }

  void changeToDark() {
    currentTheme = ThemeMode.dark;
    print('dark');
    notifyListeners();
  }
}
