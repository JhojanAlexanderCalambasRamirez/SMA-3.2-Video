import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  /// Guarda un dato en el almacenamiento local
  static Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Obtiene un dato del almacenamiento local
  static Future<String?> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Elimina un dato del almacenamiento local
  static Future<void> removeData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
