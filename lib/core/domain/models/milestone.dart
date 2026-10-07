import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';

@immutable
class Milestone {
  const Milestone({
    required this.id,
    required this.childId,
    required this.category,
    required this.title,
    required this.datePrecision,
    required this.createdAt,
    required this.updatedAt,
    this.eventDate,
    this.description,
    this.locationText,
    this.peoplePresent,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String category;
  final String title;
  final DateTime? eventDate;
  final DatePrecision datePrecision;
  final String? description;
  final String? locationText;
  final String? peoplePresent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Milestone copyWith({
    String? id,
    String? childId,
    String? category,
    String? title,
    DateTime? eventDate,
    bool clearEventDate = false,
    DatePrecision? datePrecision,
    String? description,
    bool clearDescription = false,
    String? locationText,
    bool clearLocationText = false,
    String? peoplePresent,
    bool clearPeoplePresent = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Milestone(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      category: category ?? this.category,
      title: title ?? this.title,
      eventDate: clearEventDate ? null : (eventDate ?? this.eventDate),
      datePrecision: datePrecision ?? this.datePrecision,
      description: clearDescription ? null : (description ?? this.description),
      locationText: clearLocationText
          ? null
          : (locationText ?? this.locationText),
      peoplePresent: clearPeoplePresent
          ? null
          : (peoplePresent ?? this.peoplePresent),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

abstract final class MilestoneCategories {
  static const movement = 'movement';
  static const speech = 'speech';
  static const social = 'social';
  static const selfCare = 'self_care';
  static const learning = 'learning';
  static const custom = 'custom';

  static const all = [
    movement,
    speech,
    social,
    selfCare,
    learning,
    custom,
  ];
}
