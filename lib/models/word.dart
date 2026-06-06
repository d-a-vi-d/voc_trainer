import 'package:json_annotation/json_annotation.dart';
part 'word.g.dart';

@JsonSerializable()
class LanguageLabel {
  final String label;
  const LanguageLabel({required this.label});
  factory LanguageLabel.fromJson(Map<String, dynamic> json) => _$LanguageLabelFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Word {
  final int? id;
  String term;
  String definition;
  final int languageId;
  bool learned;
  final LanguageLabel? languages;
  String get language => languages?.label ?? '';

  Word({
    this.id,
    required this.term,
    required this.definition,
    required this.languageId,
    this.learned = false,
    this.languages,
  });

  Map<String, dynamic> toJson() => _$WordToJson(this);

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  //crazy code für wörter löschen
  //dafür muss ich bei der quizlet funktion einfach words.remove machen

  // @override
  // bool operator ==(Object other) =>
  //     other is Word &&
  //     term == other.term &&
  //     definition == other.definition &&
  //     language == other.language;

  // int get hashCode => Object.hash(term, definition, language);
}
