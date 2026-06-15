// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:voc_trainer/provider/settings_provider.dart';

// class SettingsService {
//   static const _showAlreadyLearnedKey = 'showAlreadyLearned';
//   static const _currentLanguageModeKey = 'frontLanguage';
//   static bool showAlreadyLearned = false;
//   static CurrentLanguageMode currentLanguageMode = CurrentLanguageMode.home;

  // static Future<void> loadSettings() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   showAlreadyLearned = prefs.getBool(_showAlreadyLearnedKey) ?? false;
  //   currentLanguageMode = CurrentLanguageMode.values.byName(
  //     prefs.getString(_currentLanguageModeKey) ?? "home",
  //   );
  // }

  // static Future<void> saveSettings() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(_showAlreadyLearnedKey, showAlreadyLearned);
  //   await prefs.setString(_currentLanguageModeKey, currentLanguageMode.name);
  // }

  // static Future<void> saveLanguages() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList(_langKey, languages);
  // }
// }
