import 'package:flutter/foundation.dart';

@immutable
class Allergy {
  const Allergy({
    required this.id,
    required this.childId,
    required this.allergen,
    required this.allergyType,
    required this.severity,
    required this.createdAt,
    required this.updatedAt,
    this.reaction,
    this.firstObserved,
    this.doctorConfirmed = false,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String allergen;
  final String allergyType;
  final String? reaction;
  final String severity;
  final DateTime? firstObserved;
  final bool doctorConfirmed;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Allergy copyWith({
    String? id,
    String? childId,
    String? allergen,
    String? allergyType,
    String? reaction,
    bool clearReaction = false,
    String? severity,
    DateTime? firstObserved,
    bool clearFirstObserved = false,
    bool? doctorConfirmed,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Allergy(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      allergen: allergen ?? this.allergen,
      allergyType: allergyType ?? this.allergyType,
      reaction: clearReaction ? null : (reaction ?? this.reaction),
      severity: severity ?? this.severity,
      firstObserved: clearFirstObserved
          ? null
          : (firstObserved ?? this.firstObserved),
      doctorConfirmed: doctorConfirmed ?? this.doctorConfirmed,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

abstract final class AllergyTypes {
  static const food = 'food';
  static const medicine = 'medicine';
  static const environmental = 'environmental';
  static const unknown = 'unknown';

  static const all = [food, medicine, environmental, unknown];
}

abstract final class AllergySeverities {
  static const mild = 'mild';
  static const moderate = 'moderate';
  static const severe = 'severe';
  static const unknown = 'unknown';

  static const all = [mild, moderate, severe, unknown];
}
