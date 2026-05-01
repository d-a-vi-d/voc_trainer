import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _showAlreadyLearnedKey = 'showAlreadyLearned';
  static bool showAlreadyLearned = false;
  static FrontLanguage frontLanguage = FrontLanguage.home;

  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    showAlreadyLearned = prefs.getBool(_showAlreadyLearnedKey);
  }
}

enum FrontLanguage { home, foreign, random }
