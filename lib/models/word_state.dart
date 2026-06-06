import 'package:voc_trainer/models/language.dart';
import 'package:voc_trainer/models/word.dart';

class WordState {
  final List<Word> words;
  final List<Language> languages;

  const WordState({required this.words, required this.languages});
}
