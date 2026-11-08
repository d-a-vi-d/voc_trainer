import 'package:json_annotation/json_annotation.dart';
part 'word.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Word {
  @JsonKey(includeToJson: false)
  final int? id;
  final String term;
  final String definition;
  final int languageId;
  final bool learned;
  final bool marked;

  Word({
    this.id,
    required this.term,
    required this.definition,
    required this.languageId,
    this.learned = false,
    this.marked = false,
  });

  Map<String, dynamic> toJson() => _$WordToJson(this);

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Word copyWith({String? term, String? definition, bool? learned, bool? marked}) => Word(
    id: id,
    term: term ?? this.term,
    definition: definition ?? this.definition,
    languageId: languageId,
    learned: learned ?? this.learned,
    marked: marked ?? this.marked,
  );

  @override
  bool operator ==(Object other) =>
      other is Word &&
      term == other.term &&
      definition == other.definition &&
      languageId == other.languageId;

  @override
  int get hashCode => Object.hash(term, definition);
}
