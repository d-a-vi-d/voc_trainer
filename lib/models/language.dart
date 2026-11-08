import 'package:json_annotation/json_annotation.dart';
part 'language.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Language {
  final int? id;
  final String label;
  @JsonKey(defaultValue: "")
  final String notes;

  const Language({this.id, required this.label, required this.notes});

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  Language copyWith({String? label, String? notes}) =>
      Language(id: id, label: label ?? this.label, notes: notes ?? this.notes);
}
