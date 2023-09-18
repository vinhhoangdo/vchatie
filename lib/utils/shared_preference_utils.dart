import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  Future<SharedPreferences> sharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<dynamic> read(String key) async {
    final prefs = await sharedPreferences();
    return prefs.get(key) ?? "";
  }

  Future<dynamic> write(String key, dynamic value) async {
    final prefs = await sharedPreferences();
    prefs.setString(key, value);
  }

  void cleanLocalData() async {
    final prefs = await sharedPreferences();
    prefs.clear();
  }
}
