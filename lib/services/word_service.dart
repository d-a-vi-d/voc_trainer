import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class WordService {
  static const _key = 'words';
  static List<Word> words = [];

  static Future<void> loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    words = jsonList
        .map((jsonWord) => Word.fromJson(json.decode(jsonWord)))
        .toList();
  }

  static Future<void> saveWords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = words.map((word) => json.encode(word.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> addWord(Word word) async {
    words.add(word);
    await saveWords();
  }

  static Future<void> removeWord(Word word) async {
    words.remove(word);
    await saveWords();
  }

  static Future<void> update() async {
    await saveWords();
  }

  static List<Word> getWordsForLanguage(String language) {
    return words.where((w) => w.language == language).toList();
  }
}
