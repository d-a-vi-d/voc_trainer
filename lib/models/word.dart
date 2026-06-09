import 'package:json_annotation/json_annotation.dart';
import 'package:voc_trainer/models/language.dart';
part 'word.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Word {
  @JsonKey(includeToJson: false)
  final int? id;
  String term;
  String definition;
  final int languageId;
  bool learned;
  @JsonKey(includeToJson: false)
  final Language? languages;
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

  @override
  bool operator ==(Object other) =>
      other is Word &&
      term == other.term &&
      definition == other.definition &&
      language == other.language;

  int get hashCode => Object.hash(term, definition, language);
}
