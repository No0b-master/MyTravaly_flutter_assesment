import 'package:flutter/material.dart';
import '../../Constants/prefs.dart';
import '../../Utils/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencyCode = SessionManager.getString(Prefs.currency).isEmpty
      ? "INR"
      : SessionManager.getString(Prefs.currency);

  String get currencyCode => _currencyCode;

  Future<void> setCurrency(String code) async {
    _currencyCode = code;
    await SessionManager.setString(Prefs.currency, code);
    notifyListeners(); // 🔹 Triggers UI rebuild wherever used
  }
}
