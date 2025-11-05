import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Highlight.g.dart';

/// Represents a highlighted verse with color and optional note
@JsonSerializable()
class VerseHighlight {
  final String book;
  final int chapter;
  final int verse;
  final int colorValue;
  final DateTime createdAt;
  final String? note;

  VerseHighlight({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.colorValue,
    required this.createdAt,
    this.note,
  });

  /// Factory constructor for creating from Color object
  factory VerseHighlight.create({
    required String book,
    required int chapter,
    required int verse,
    required Color color,
    DateTime? createdAt,
    String? note,
  }) {
    return VerseHighlight(
      book: book,
      chapter: chapter,
      verse: verse,
      colorValue: color.value,
      createdAt: createdAt ?? DateTime.now(),
      note: note,
    );
  }

  /// Get the Color object from the stored int value
  Color get color => Color(colorValue);

  /// Create a unique identifier for this verse
  String get verseId => '$book:$chapter:$verse';

  /// Factory constructor for creating a new instance from JSON
  factory VerseHighlight.fromJson(Map<String, dynamic> json) =>
      _$VerseHighlightFromJson(json);

  /// Convert this instance to JSON
  Map<String, dynamic> toJson() => _$VerseHighlightToJson(this);

  /// Create a copy with some fields replaced
  VerseHighlight copyWith({
    String? book,
    int? chapter,
    int? verse,
    Color? color,
    DateTime? createdAt,
    String? note,
  }) {
    return VerseHighlight(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      colorValue: color?.value ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseHighlight &&
          runtimeType == other.runtimeType &&
          book == other.book &&
          chapter == other.chapter &&
          verse == other.verse;

  @override
  int get hashCode => book.hashCode ^ chapter.hashCode ^ verse.hashCode;
}

/// Predefined highlight colors
class HighlightColor {
  static const yellow = Color(0xFFFFEB3B);

  /// List of all available colors
  static const List<Color> all = [
    yellow,
  ];

  /// Get color name for display
  static String getColorName(Color color) {
    if (color.value == yellow.value) return '노란색';
    return '사용자 정의';
  }
}
