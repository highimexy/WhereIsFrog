import 'package:shared_preferences/shared_preferences.dart';

/// Flaga pierwszego uruchomienia — decyduje, czy pokazać onboarding.
class FirstLaunch {
  FirstLaunch._();

  static const _key = 'few_bears_onboarding_completed';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_key) ?? false);
  }

  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
