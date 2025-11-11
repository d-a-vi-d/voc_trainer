import 'dart:convert';
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
    words = jsonList
        .map((jsonWord) => Word.fromJson(json.decode(jsonWord)))
        .toList();


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
}
