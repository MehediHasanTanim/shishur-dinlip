import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/media_asset_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/medical_document_mapper.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class MedicalDocumentsRepository implements Repository {
  Future<List<MedicalDocument>> forChild(
    String childId, {
    String? documentType,
    int? limit,
  });
  Future<MedicalDocument?> getById(String id);
  Future<MedicalDocument> save({
    required MedicalDocument document,
    String? pendingFilePath,
    bool isDocument = true,
  });
  Future<void> softDelete(String id);
}

class DriftMedicalDocumentsRepository extends RepositoryBase
    implements MedicalDocumentsRepository {
  DriftMedicalDocumentsRepository(super.db, {required this.media});

  final MediaService media;

  @override
  Future<List<MedicalDocument>> forChild(
    String childId, {
    String? documentType,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.medicalDocumentsDao.forChild(
        childId,
        documentType: documentType,
        limit: limit,
      );
      final result = <MedicalDocument>[];
      for (final row in rows) {
        final asset = await db.mediaAssetsDao.getById(row.mediaAssetId);
        result.add(
          MedicalDocumentMapper.toDomain(
            row,
            media: asset == null ? null : MediaAssetMapper.toDomain(asset),
          ),
        );
      }
      return result;
    }, operation: 'medicalDocs.forChild');
  }

  @override
  Future<MedicalDocument?> getById(String id) {
    return guard(() async {
      final row = await db.medicalDocumentsDao.getById(id);
      if (row == null) return null;
      final asset = await db.mediaAssetsDao.getById(row.mediaAssetId);
      return MedicalDocumentMapper.toDomain(
        row,
        media: asset == null ? null : MediaAssetMapper.toDomain(asset),
      );
    }, operation: 'medicalDocs.getById');
  }

  @override
  Future<MedicalDocument> save({
    required MedicalDocument document,
    String? pendingFilePath,
    bool isDocument = true,
  }) {
    return guard(() async {
      if (document.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Document title is required.');
      }
      if (!MedicalDocumentTypes.all.contains(document.documentType)) {
        throw const ValidationFailure(message: 'Invalid document type.');
      }

      final nowUtc = now();
      final id = document.id.isEmpty ? ids.next() : document.id;
      final existing = await db.medicalDocumentsDao.getById(id);

      var mediaAssetId = document.mediaAssetId;
      if (pendingFilePath != null && pendingFilePath.isNotEmpty) {
        final file = File(pendingFilePath);
        final name = p.basename(pendingFilePath);
        final asset = isDocument
            ? await media.importDocument(
                sourceFile: file,
                childId: document.childId,
                originalFilename: name,
              )
            : await media.importImage(
                sourceFile: file,
                childId: document.childId,
                originalFilename: name,
              );
        mediaAssetId = asset.id;
      }

      if (mediaAssetId.isEmpty) {
        throw const ValidationFailure(message: 'A document file is required.');
      }

      DateTime? dayOnly(DateTime? d) =>
          d == null ? null : DateTime(d.year, d.month, d.day);

      final toSave = document.copyWith(
        id: id,
        title: document.title.trim(),
        mediaAssetId: mediaAssetId,
        documentDate: dayOnly(document.documentDate),
        clearDocumentDate: document.documentDate == null,
        notes: _trimOrNull(document.notes),
        clearNotes: _trimOrNull(document.notes) == null,
        illnessId: _trimOrNull(document.illnessId),
        clearIllnessId: _trimOrNull(document.illnessId) == null,
        doctorVisitId: _trimOrNull(document.doctorVisitId),
        clearDoctorVisitId: _trimOrNull(document.doctorVisitId) == null,
        vaccinationId: _trimOrNull(document.vaccinationId),
        clearVaccinationId: _trimOrNull(document.vaccinationId) == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.medicalDocumentsDao.upsert(
        MedicalDocumentMapper.toCompanion(toSave),
      );
      return (await getById(id))!;
    }, operation: 'medicalDocs.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.medicalDocumentsDao.softDelete(id, now());
    }, operation: 'medicalDocs.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
