import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:mytravaly_flutter_assesment/Utils/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeManager() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme(_isDarkMode);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = SessionManager.getBoolean(Prefs.isDarkMode);
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    SessionManager.setBoolean(Prefs.isDarkMode , isDark);
  }
}
