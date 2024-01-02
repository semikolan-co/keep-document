import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) {
      return null;
    } else {
      // return json.decode(prefs.getString(key)!);
      return prefs.getString(key);
    }
  }

  static save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    // print("SAVING $value");
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
