import 'package:flutter/foundation.dart';

@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.childId,
    required this.entryType,
    required this.body,
    required this.eventDate,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.mood,
    this.locationText,
    this.isPrivate = false,
    this.isFavorite = false,
    this.deletedAt,
    this.tagNames = const [],
  });

  final String id;
  final String childId;
  final String entryType;
  final String? title;
  final String body;
  final DateTime eventDate;
  final String? mood;
  final String? locationText;
  final bool isPrivate;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<String> tagNames;

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    final line = body.trim().split('\n').first;
    if (line.isEmpty) return 'Memory';
    return line.length > 48 ? '${line.substring(0, 48)}…' : line;
  }

  JournalEntry copyWith({
    String? id,
    String? childId,
    String? entryType,
    String? title,
    bool clearTitle = false,
    String? body,
    DateTime? eventDate,
    String? mood,
    bool clearMood = false,
    String? locationText,
    bool clearLocationText = false,
    bool? isPrivate,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
    List<String>? tagNames,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      entryType: entryType ?? this.entryType,
      title: clearTitle ? null : (title ?? this.title),
      body: body ?? this.body,
      eventDate: eventDate ?? this.eventDate,
      mood: clearMood ? null : (mood ?? this.mood),
      locationText: clearLocationText
          ? null
          : (locationText ?? this.locationText),
      isPrivate: isPrivate ?? this.isPrivate,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
      tagNames: tagNames ?? this.tagNames,
    );
  }
}
