import 'package:flutter/foundation.dart';

@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.childId,
    required this.title,
    required this.category,
    required this.eventDate,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.isFavorite = false,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String title;
  final String category;
  final DateTime eventDate;
  final String? description;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Achievement copyWith({
    String? id,
    String? childId,
    String? title,
    String? category,
    DateTime? eventDate,
    String? description,
    bool clearDescription = false,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Achievement(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      title: title ?? this.title,
      category: category ?? this.category,
      eventDate: eventDate ?? this.eventDate,
      description: clearDescription ? null : (description ?? this.description),
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
