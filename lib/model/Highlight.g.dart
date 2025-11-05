// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Highlight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseHighlight _$VerseHighlightFromJson(Map<String, dynamic> json) =>
    VerseHighlight(
      book: json['book'] as String,
      chapter: (json['chapter'] as num).toInt(),
      verse: (json['verse'] as num).toInt(),
      colorValue: (json['colorValue'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$VerseHighlightToJson(VerseHighlight instance) =>
    <String, dynamic>{
      'book': instance.book,
      'chapter': instance.chapter,
      'verse': instance.verse,
      'colorValue': instance.colorValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'note': instance.note,
    };
