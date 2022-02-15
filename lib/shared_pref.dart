import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    return data != null ? json.decode(prefs.getString(key)!) : null;
  }

  static readToken() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('TOKEN');
    return data != null ? json.decode(prefs.getString('TOKEN')!) : null;
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
