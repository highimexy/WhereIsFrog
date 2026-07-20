import 'package:shared_preferences/shared_preferences.dart';

/// Potwierdzenie pełnoletności — wymagane przed pokazaniem treści
/// związanych z alkoholem (App Store / Play Store content rating).
class AgeGate {
  AgeGate._();

  static const _key = 'few_bears_age_confirmed';

  static Future<bool> isConfirmed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> confirm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
