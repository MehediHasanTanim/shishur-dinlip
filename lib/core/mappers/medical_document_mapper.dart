import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';

abstract final class MedicalDocumentMapper {
  static MedicalDocument toDomain(
    MedicalDocumentRow row, {
    MediaAsset? media,
  }) {
    return MedicalDocument(
      id: row.id,
      childId: row.childId,
      documentType: row.documentType,
      title: row.title,
      documentDate: row.documentDate,
      illnessId: row.illnessId,
      doctorVisitId: row.doctorVisitId,
      vaccinationId: row.vaccinationId,
      mediaAssetId: row.mediaAssetId,
      notes: row.notes,
      media: media,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static MedicalDocumentsCompanion toCompanion(MedicalDocument item) {
    return MedicalDocumentsCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      documentType: Value(item.documentType),
      title: Value(item.title),
      documentDate: Value(item.documentDate),
      illnessId: Value(item.illnessId),
      doctorVisitId: Value(item.doctorVisitId),
      vaccinationId: Value(item.vaccinationId),
      mediaAssetId: Value(item.mediaAssetId),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
