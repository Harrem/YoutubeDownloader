import 'package:shared_preferences/shared_preferences.dart';

///save an integer in shared preferences
Future<bool> setDouble(String key, double value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setDouble(key, value);
}

///Save a string in shared preferences
Future<bool> setString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(key, value);
}

///save an integer in shared preferences
Future<bool> setInt(String key, int value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setInt(key, value);
}
