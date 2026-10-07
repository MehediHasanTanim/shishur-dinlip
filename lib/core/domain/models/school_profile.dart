import 'package:flutter/foundation.dart';

@immutable
class SchoolProfile {
  const SchoolProfile({
    required this.id,
    required this.childId,
    required this.schoolName,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.endDate,
    this.className,
    this.teacherName,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String schoolName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? className;
  final String? teacherName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isCurrent => endDate == null;

  SchoolProfile copyWith({
    String? id,
    String? childId,
    String? schoolName,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? className,
    bool clearClassName = false,
    String? teacherName,
    bool clearTeacherName = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return SchoolProfile(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      schoolName: schoolName ?? this.schoolName,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      className: clearClassName ? null : (className ?? this.className),
      teacherName: clearTeacherName ? null : (teacherName ?? this.teacherName),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
