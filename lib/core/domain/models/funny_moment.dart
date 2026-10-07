import 'package:flutter/foundation.dart';

@immutable
class FunnyMoment {
  const FunnyMoment({
    required this.id,
    required this.childId,
    required this.eventDate,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.story,
    this.quoteText,
    this.peoplePresent,
    this.isFavorite = false,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final DateTime eventDate;
  final String? title;
  final String? story;
  final String? quoteText;
  final String? peoplePresent;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    final q = quoteText?.trim();
    if (q != null && q.isNotEmpty) {
      return q.length > 48 ? '${q.substring(0, 48)}…' : q;
    }
    final s = story?.trim();
    if (s != null && s.isNotEmpty) {
      return s.length > 48 ? '${s.substring(0, 48)}…' : s;
    }
    return 'Funny moment';
  }

  FunnyMoment copyWith({
    String? id,
    String? childId,
    DateTime? eventDate,
    String? title,
    bool clearTitle = false,
    String? story,
    bool clearStory = false,
    String? quoteText,
    bool clearQuoteText = false,
    String? peoplePresent,
    bool clearPeoplePresent = false,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return FunnyMoment(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      eventDate: eventDate ?? this.eventDate,
      title: clearTitle ? null : (title ?? this.title),
      story: clearStory ? null : (story ?? this.story),
      quoteText: clearQuoteText ? null : (quoteText ?? this.quoteText),
      peoplePresent: clearPeoplePresent
          ? null
          : (peoplePresent ?? this.peoplePresent),
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
