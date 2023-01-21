import 'package:shared_preferences/shared_preferences.dart';

///get a saved string in shared preferernces
Future<String?> getString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

///get a saved double in shared preferernces
Future<double?> getDouble(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

///get a saved int in shared preferernces
Future<int?> getInt(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}
