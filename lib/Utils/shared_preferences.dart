import 'package:shared_preferences/shared_preferences.dart';



class SessionManager {
  static Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key, [String? defValue]) {
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static int getInteger(String key, [int? defValue]) {
    final str = getString(key);
    return int.tryParse(str) ?? defValue ?? 0;
  }

  static bool getBoolean(String key, [bool? defValue]) {
    final str = getString(key);
    if (str == 'true') return true;
    if (str == 'false') return false;
    return defValue ?? false;
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setInteger(String key, int value) async {
    return setString(key, value.toString());
  }

  static Future<bool> setBoolean(String key, bool value) async {
    return setString(key, value.toString());
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final joined = value.join(',');
    return setString(key, joined);
  }

  static Future<bool> removePref(String key) async {
    var prefs = await _instance;
    return prefs.remove(key);
  }

  static Future<void> cleanPrefrence() async {
    await _prefsInstance?.clear();
  }
}
