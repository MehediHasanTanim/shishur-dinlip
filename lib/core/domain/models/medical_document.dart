import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';

@immutable
class MedicalDocument {
  const MedicalDocument({
    required this.id,
    required this.childId,
    required this.documentType,
    required this.title,
    required this.mediaAssetId,
    required this.createdAt,
    required this.updatedAt,
    this.documentDate,
    this.illnessId,
    this.doctorVisitId,
    this.vaccinationId,
    this.notes,
    this.media,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String documentType;
  final String title;
  final DateTime? documentDate;
  final String? illnessId;
  final String? doctorVisitId;
  final String? vaccinationId;
  final String mediaAssetId;
  final String? notes;
  final MediaAsset? media;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  MedicalDocument copyWith({
    String? id,
    String? childId,
    String? documentType,
    String? title,
    DateTime? documentDate,
    bool clearDocumentDate = false,
    String? illnessId,
    bool clearIllnessId = false,
    String? doctorVisitId,
    bool clearDoctorVisitId = false,
    String? vaccinationId,
    bool clearVaccinationId = false,
    String? mediaAssetId,
    String? notes,
    bool clearNotes = false,
    MediaAsset? media,
    bool clearMedia = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return MedicalDocument(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      documentDate: clearDocumentDate
          ? null
          : (documentDate ?? this.documentDate),
      illnessId: clearIllnessId ? null : (illnessId ?? this.illnessId),
      doctorVisitId: clearDoctorVisitId
          ? null
          : (doctorVisitId ?? this.doctorVisitId),
      vaccinationId: clearVaccinationId
          ? null
          : (vaccinationId ?? this.vaccinationId),
      mediaAssetId: mediaAssetId ?? this.mediaAssetId,
      notes: clearNotes ? null : (notes ?? this.notes),
      media: clearMedia ? null : (media ?? this.media),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

abstract final class MedicalDocumentTypes {
  static const prescription = 'prescription';
  static const diagnosticReport = 'diagnostic_report';
  static const vaccinationCard = 'vaccination_card';
  static const dischargeSummary = 'discharge_summary';
  static const certificate = 'certificate';
  static const other = 'other';

  static const all = [
    prescription,
    diagnosticReport,
    vaccinationCard,
    dischargeSummary,
    certificate,
    other,
  ];
}
