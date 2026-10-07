import 'package:flutter/foundation.dart';

@immutable
class SchoolEvent {
  const SchoolEvent({
    required this.id,
    required this.childId,
    required this.eventType,
    required this.title,
    required this.eventDate,
    required this.createdAt,
    required this.updatedAt,
    this.schoolProfileId,
    this.description,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String? schoolProfileId;
  final String eventType;
  final String title;
  final DateTime eventDate;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  SchoolEvent copyWith({
    String? id,
    String? childId,
    String? schoolProfileId,
    bool clearSchoolProfileId = false,
    String? eventType,
    String? title,
    DateTime? eventDate,
    String? description,
    bool clearDescription = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return SchoolEvent(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      schoolProfileId: clearSchoolProfileId
          ? null
          : (schoolProfileId ?? this.schoolProfileId),
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      description: clearDescription ? null : (description ?? this.description),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

abstract final class SchoolEventTypes {
  static const firstDay = 'first_day';
  static const exam = 'exam';
  static const performance = 'performance';
  static const sports = 'sports';
  static const certificate = 'certificate';
  static const classPromotion = 'class_promotion';
  static const project = 'project';
  static const reportCard = 'report_card';
  static const custom = 'custom';

  static const all = [
    firstDay,
    exam,
    performance,
    sports,
    certificate,
    classPromotion,
    project,
    reportCard,
    custom,
  ];
}
