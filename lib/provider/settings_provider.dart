// lib/provider/settings_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voc_trainer/services/settings_service.dart'; // für CurrentLanguageMode

part 'settings_provider.g.dart';

class SettingsState {
  final bool showAlreadyLearned;
  final CurrentLanguageMode languageMode;

  const SettingsState({required this.showAlreadyLearned, required this.languageMode});

  SettingsState copyWith({bool? showAlreadyLearned, CurrentLanguageMode? languageMode}) =>
      SettingsState(
        showAlreadyLearned: showAlreadyLearned ?? this.showAlreadyLearned,
        languageMode: languageMode ?? this.languageMode,
      );
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const _showAlreadyLearnedKey = 'showAlreadyLearned';
  static const _currentLanguageModeKey = 'frontLanguage';

  @override
  Future<SettingsState> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsState(
      showAlreadyLearned: prefs.getBool(_showAlreadyLearnedKey) ?? false,
      languageMode: CurrentLanguageMode.values.byName(
        prefs.getString(_currentLanguageModeKey) ?? 'home',
      ),
    );
  }

  Future<void> setShowAlreadyLearned(bool value) async {
    final prev = await future;
    state = AsyncData(prev.copyWith(showAlreadyLearned: value));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showAlreadyLearnedKey, value);
  }

  Future<void> setLanguageMode(CurrentLanguageMode mode) async {
    final prev = await future;
    state = AsyncData(prev.copyWith(languageMode: mode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentLanguageModeKey, mode.name);
  }
}
