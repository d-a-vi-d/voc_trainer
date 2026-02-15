import 'dart:convert';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class WordService {
  static const _key = 'words';
  static const _langKey = 'languages';
  static List<Word> words = [];
  static List<String> languages = [];

  static Future<void> load() async {
    await loadWords();
    await loadLanguages();
  }

  static Future<void> loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    languages = prefs.getStringList(_langKey) ?? ['Englisch'];
  }

  static Future<void> loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    words = jsonList.map((jsonWord) => Word.fromJson(json.decode(jsonWord))).toList();

    //     final quizlet = """""";
    //     final wordsRaw = quizlet.split("newline");
    //     for (final wordRaw in wordsRaw) {
    //       if (wordRaw.isEmpty) continue;
    //       final parts = wordRaw.split("penis");
    //       final word = Word(language: "Englisch", word: parts[0], translation: parts[1]);
    //       words.add(word);
    //     }
    //     saveWords();
  }

  static Future<void> renameLanguage(int index, String newLanguageName) async {
    String oldLanguageName = WordService.languages[index];
    if (newLanguageName.isEmpty) {
      return;
    }
    //checken ob Name existiert
    if (WordService.languages.contains(newLanguageName)) {
      throw Exception("There is already a language with this name!");
    }
    WordService.languages[index] = newLanguageName;
    //Wörter umspeichern
    for (Word word in words) {
      if (word.language == oldLanguageName) {
        word.language = newLanguageName;
      }
    }
    await saveLanguages();
    await saveWords();
  }

  static Future<void> saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = words.map((word) => json.encode(word.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> saveLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_langKey, languages);
  }

  static Future<void> addWord(Word word) async {
    words.add(word);
    await saveWords();
  }

  static Future<void> removeWord(Word word) async {
    words.remove(word);
    await saveWords();
  }

  static Future<void> addLanguage(String language) async {
    if (!languages.contains(language)) {
      languages.add(language);
      await saveLanguages();
    }
  }

  static Future<void> removeLanguage(String language) async {
    if (languages.remove(language)) {
      words.removeWhere((w) => w.language == language);
      await saveLanguages();
      await saveWords();
    }
  }

  static Future<void> update() async {
    await saveWords();
  }

  static List<Word> getWordsForLanguage(String language) {
    return words.where((w) => w.language == language).toList();
  }

  static List<Word> getWordsForSearch(String currentLanguage, String searchInput) {
    return words.where((w) {
      bool matchesExactly = w.word.toLowerCase().contains(searchInput) || w.translation.toLowerCase().contains(searchInput);
      bool matchesMostly =
          partialRatio(searchInput.toLowerCase(), w.word.toLowerCase()) > 70 ||
          partialRatio(searchInput.toLowerCase(), w.translation.toLowerCase()) > 70;
      return w.language == currentLanguage && matchesExactly || matchesMostly;
    }).toList();
  }
}
