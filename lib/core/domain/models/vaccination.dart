import 'package:flutter/foundation.dart';

@immutable
class Vaccination {
  const Vaccination({
    required this.id,
    required this.childId,
    required this.vaccineName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.doseLabel,
    this.scheduledDate,
    this.givenDate,
    this.providerName,
    this.clinicName,
    this.batchNumber,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String vaccineName;
  final String? doseLabel;
  final DateTime? scheduledDate;
  final DateTime? givenDate;
  final String status;
  final String? providerName;
  final String? clinicName;
  final String? batchNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Vaccination copyWith({
    String? id,
    String? childId,
    String? vaccineName,
    String? doseLabel,
    bool clearDoseLabel = false,
    DateTime? scheduledDate,
    bool clearScheduledDate = false,
    DateTime? givenDate,
    bool clearGivenDate = false,
    String? status,
    String? providerName,
    bool clearProviderName = false,
    String? clinicName,
    bool clearClinicName = false,
    String? batchNumber,
    bool clearBatchNumber = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Vaccination(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      vaccineName: vaccineName ?? this.vaccineName,
      doseLabel: clearDoseLabel ? null : (doseLabel ?? this.doseLabel),
      scheduledDate: clearScheduledDate
          ? null
          : (scheduledDate ?? this.scheduledDate),
      givenDate: clearGivenDate ? null : (givenDate ?? this.givenDate),
      status: status ?? this.status,
      providerName: clearProviderName
          ? null
          : (providerName ?? this.providerName),
      clinicName: clearClinicName ? null : (clinicName ?? this.clinicName),
      batchNumber: clearBatchNumber ? null : (batchNumber ?? this.batchNumber),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

abstract final class VaccinationStatuses {
  static const upcoming = 'upcoming';
  static const completed = 'completed';
  static const delayed = 'delayed';
  static const skipped = 'skipped';
  static const unknown = 'unknown';

  static const all = [upcoming, completed, delayed, skipped, unknown];
}
