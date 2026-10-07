import 'package:flutter/foundation.dart';

@immutable
class DoctorVisit {
  const DoctorVisit({
    required this.id,
    required this.childId,
    required this.visitDate,
    required this.doctorName,
    required this.createdAt,
    required this.updatedAt,
    this.specialty,
    this.hospitalOrChamber,
    this.reason,
    this.symptoms,
    this.diagnosis,
    this.testsAdvised,
    this.followUpDate,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final DateTime visitDate;
  final String doctorName;
  final String? specialty;
  final String? hospitalOrChamber;
  final String? reason;
  final String? symptoms;
  final String? diagnosis;
  final String? testsAdvised;
  final DateTime? followUpDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  DoctorVisit copyWith({
    String? id,
    String? childId,
    DateTime? visitDate,
    String? doctorName,
    String? specialty,
    bool clearSpecialty = false,
    String? hospitalOrChamber,
    bool clearHospitalOrChamber = false,
    String? reason,
    bool clearReason = false,
    String? symptoms,
    bool clearSymptoms = false,
    String? diagnosis,
    bool clearDiagnosis = false,
    String? testsAdvised,
    bool clearTestsAdvised = false,
    DateTime? followUpDate,
    bool clearFollowUpDate = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return DoctorVisit(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      visitDate: visitDate ?? this.visitDate,
      doctorName: doctorName ?? this.doctorName,
      specialty: clearSpecialty ? null : (specialty ?? this.specialty),
      hospitalOrChamber: clearHospitalOrChamber
          ? null
          : (hospitalOrChamber ?? this.hospitalOrChamber),
      reason: clearReason ? null : (reason ?? this.reason),
      symptoms: clearSymptoms ? null : (symptoms ?? this.symptoms),
      diagnosis: clearDiagnosis ? null : (diagnosis ?? this.diagnosis),
      testsAdvised: clearTestsAdvised
          ? null
          : (testsAdvised ?? this.testsAdvised),
      followUpDate: clearFollowUpDate
          ? null
          : (followUpDate ?? this.followUpDate),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
