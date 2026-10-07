import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class IllnessEpisode {
  const IllnessEpisode({
    required this.id,
    required this.childId,
    required this.title,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
    this.symptoms = const [],
    this.maxTemperatureC,
    this.diagnosis,
    this.doctorVisitId,
    this.recoveryNote,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> symptoms;
  final double? maxTemperatureC;
  final String? diagnosis;
  final String? doctorVisitId;
  final String? recoveryNote;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isOngoing => endDate == null;

  IllnessEpisode copyWith({
    String? id,
    String? childId,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    List<String>? symptoms,
    double? maxTemperatureC,
    bool clearMaxTemperatureC = false,
    String? diagnosis,
    bool clearDiagnosis = false,
    String? doctorVisitId,
    bool clearDoctorVisitId = false,
    String? recoveryNote,
    bool clearRecoveryNote = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return IllnessEpisode(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      symptoms: symptoms ?? this.symptoms,
      maxTemperatureC: clearMaxTemperatureC
          ? null
          : (maxTemperatureC ?? this.maxTemperatureC),
      diagnosis: clearDiagnosis ? null : (diagnosis ?? this.diagnosis),
      doctorVisitId: clearDoctorVisitId
          ? null
          : (doctorVisitId ?? this.doctorVisitId),
      recoveryNote: clearRecoveryNote
          ? null
          : (recoveryNote ?? this.recoveryNote),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }

  static String? encodeSymptoms(List<String> symptoms) {
    if (symptoms.isEmpty) return null;
    return jsonEncode(symptoms);
  }

  static List<String> decodeSymptoms(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return const [];
  }
}

abstract final class IllnessSymptoms {
  static const fever = 'fever';
  static const cough = 'cough';
  static const cold = 'cold';
  static const vomiting = 'vomiting';
  static const diarrhea = 'diarrhea';
  static const rash = 'rash';
  static const headache = 'headache';
  static const stomachPain = 'stomach_pain';
  static const breathingDifficulty = 'breathing_difficulty';
  static const allergy = 'allergy';
  static const injury = 'injury';
  static const other = 'other';

  static const all = [
    fever,
    cough,
    cold,
    vomiting,
    diarrhea,
    rash,
    headache,
    stomachPain,
    breathingDifficulty,
    allergy,
    injury,
    other,
  ];
}
