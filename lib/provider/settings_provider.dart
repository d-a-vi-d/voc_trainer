// lib/provider/settings_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

enum LanguageMode { home, foreign, random }

class SettingsState {
  final bool showAlreadyLearned;
  final LanguageMode languageMode;
  final bool darkMode;

  const SettingsState({
    required this.showAlreadyLearned,
    required this.languageMode,
    this.darkMode = false,
  });

  SettingsState copyWith({bool? showAlreadyLearned, LanguageMode? languageMode, bool? darkMode}) =>
      SettingsState(
        showAlreadyLearned: showAlreadyLearned ?? this.showAlreadyLearned,
        languageMode: languageMode ?? this.languageMode,
        darkMode: darkMode ?? this.darkMode,
      );
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const _showAlreadyLearnedKey = 'showAlreadyLearned';
  static const _languageModeKey = 'frontLanguage';
  static const _darkModeKey = 'darkMode';

  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsState(
      showAlreadyLearned: prefs.getBool(_showAlreadyLearnedKey) ?? false,
      languageMode: LanguageMode.values.byName(prefs.getString(_languageModeKey) ?? 'home'),
      darkMode: prefs.getBool(_darkModeKey) ?? false, // neu: Standard hell
    );
  }

  Future<void> setDarkMode(bool value) async {
    final prev = await future;
    if (prev.darkMode == value) return;

    // Optimistisch: UI wechselt sofort
    state = AsyncData(prev.copyWith(darkMode: value));

    try {
      final prefs = await SharedPreferences.getInstance();
      final ok = await prefs.setBool(_darkModeKey, value);
      if (!ok) throw Exception('Design konnte nicht gespeichert werden');
    } catch (e) {
      // Fallback: nur dieses Feld zurücksetzen, andere Änderungen bleiben
      state = AsyncData(state.requireValue.copyWith(darkMode: prev.darkMode));
      rethrow;
    }
  }

  Future<void> setShowAlreadyLearned(bool value) async {
    final prev = await future;
    state = AsyncData(prev.copyWith(showAlreadyLearned: value));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showAlreadyLearnedKey, value);
  }

  Future<void> setLanguageMode(LanguageMode mode) async {
    final prev = await future;
    state = AsyncData(prev.copyWith(languageMode: mode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageModeKey, mode.name);
  }
}
