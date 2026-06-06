// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
  id: (json['id'] as num?)?.toInt(),
  term: json['term'] as String,
  definition: json['definition'] as String,
  languageId: (json['language_id'] as num).toInt(),
  learned: json['learned'] as bool? ?? false,
  languages: json['languages'] == null
      ? null
      : Language.fromJson(json['languages'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
  'id': instance.id,
  'term': instance.term,
  'definition': instance.definition,
  'language_id': instance.languageId,
  'learned': instance.learned,
  'languages': instance.languages,
};
