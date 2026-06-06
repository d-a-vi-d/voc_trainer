import 'package:json_annotation/json_annotation.dart';
part 'language.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Language {
  final int? id;
  final String label;

  const Language({this.id, required this.label});

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}
