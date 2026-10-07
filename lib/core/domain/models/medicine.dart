import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Medicine {
  const Medicine({
    required this.id,
    required this.childId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.illnessId,
    this.doctorVisitId,
    this.strength,
    this.dosage,
    this.frequencyText,
    this.startDate,
    this.endDate,
    this.reason,
    this.prescribedBy,
    this.notes,
    this.schedules = const [],
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String? illnessId;
  final String? doctorVisitId;
  final String name;
  final String? strength;
  final String? dosage;
  final String? frequencyText;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? reason;
  final String? prescribedBy;
  final String status;
  final String? notes;
  final List<MedicineSchedule> schedules;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isActive => status == MedicineStatuses.active;

  Medicine copyWith({
    String? id,
    String? childId,
    String? illnessId,
    bool clearIllnessId = false,
    String? doctorVisitId,
    bool clearDoctorVisitId = false,
    String? name,
    String? strength,
    bool clearStrength = false,
    String? dosage,
    bool clearDosage = false,
    String? frequencyText,
    bool clearFrequencyText = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? reason,
    bool clearReason = false,
    String? prescribedBy,
    bool clearPrescribedBy = false,
    String? status,
    String? notes,
    bool clearNotes = false,
    List<MedicineSchedule>? schedules,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Medicine(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      illnessId: clearIllnessId ? null : (illnessId ?? this.illnessId),
      doctorVisitId: clearDoctorVisitId
          ? null
          : (doctorVisitId ?? this.doctorVisitId),
      name: name ?? this.name,
      strength: clearStrength ? null : (strength ?? this.strength),
      dosage: clearDosage ? null : (dosage ?? this.dosage),
      frequencyText: clearFrequencyText
          ? null
          : (frequencyText ?? this.frequencyText),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      reason: clearReason ? null : (reason ?? this.reason),
      prescribedBy: clearPrescribedBy
          ? null
          : (prescribedBy ?? this.prescribedBy),
      status: status ?? this.status,
      notes: clearNotes ? null : (notes ?? this.notes),
      schedules: schedules ?? this.schedules,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

@immutable
class MedicineSchedule {
  const MedicineSchedule({
    required this.id,
    required this.medicineId,
    required this.timeOfDay,
    required this.createdAt,
    required this.updatedAt,
    this.days = const [],
    this.notificationEnabled = false,
    this.notificationId,
    this.deletedAt,
  });

  final String id;
  final String medicineId;

  /// Local time as `HH:mm`.
  final String timeOfDay;
  final List<int> days;
  final bool notificationEnabled;
  final int? notificationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  static String? encodeDays(List<int> days) {
    if (days.isEmpty) return null;
    return jsonEncode(days);
  }

  static List<int> decodeDays(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => int.tryParse(e.toString()) ?? 0).toList();
      }
    } catch (_) {}
    return const [];
  }
}

abstract final class MedicineStatuses {
  static const active = 'active';
  static const completed = 'completed';
  static const stopped = 'stopped';
  static const asNeeded = 'as_needed';

  static const all = [active, completed, stopped, asNeeded];
}
