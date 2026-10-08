import 'dart:io';

import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/core/repository/medical_documents_repository.dart';
import 'package:shishur_dinlipi/core/repository/medicines_repository.dart';
import 'package:shishur_dinlipi/core/repository/vaccinations_repository.dart';

/// Persists OCR drafts only after explicit parent confirmation.
class OcrConfirmService {
  OcrConfirmService({
    required this.vaccinations,
    required this.medicines,
    required this.documents,
    IdGenerator? ids,
  }) : _ids = ids ?? idGenerator;

  final VaccinationsRepository vaccinations;
  final MedicinesRepository medicines;
  final MedicalDocumentsRepository documents;
  final IdGenerator _ids;

  Future<OcrConfirmResult> confirmAndSave({
    required String childId,
    required OcrReviewDraft draft,
  }) async {
    if (!draft.confirmed) {
      throw const ValidationFailure(
        message: 'Confirm the extracted details before saving.',
      );
    }
    final image = File(draft.imagePath);
    if (!await image.exists()) {
      throw const ValidationFailure(message: 'Scan image was not found.');
    }

    return switch (draft.scanType) {
      OcrScanType.vaccinationCard => _saveVaccination(childId, draft),
      OcrScanType.prescription => _savePrescription(childId, draft),
      OcrScanType.diagnosticReport => _saveDiagnostic(childId, draft),
    };
  }

  Future<OcrConfirmResult> _saveVaccination(
    String childId,
    OcrReviewDraft draft,
  ) async {
    final name = draft.valueOf(OcrFieldKeys.vaccineName)?.trim() ?? '';
    if (name.isEmpty) {
      throw const ValidationFailure(message: 'Vaccine name is required.');
    }
    final given = _parseDate(draft.valueOf(OcrFieldKeys.givenDate));
    final now = DateTime.now().toUtc();
    final vaccination = await vaccinations.save(
      vaccination: Vaccination(
        id: '',
        childId: childId,
        vaccineName: name,
        doseLabel: draft.valueOf(OcrFieldKeys.doseLabel),
        givenDate: given,
        scheduledDate: null,
        status: given != null
            ? VaccinationStatuses.completed
            : VaccinationStatuses.unknown,
        providerName: draft.valueOf(OcrFieldKeys.providerName),
        clinicName: draft.valueOf(OcrFieldKeys.clinicName),
        batchNumber: draft.valueOf(OcrFieldKeys.batchNumber),
        notes: draft.valueOf(OcrFieldKeys.notes) ??
            _rawSnippet(draft.raw.fullText),
        createdAt: now,
        updatedAt: now,
      ),
      attachments: [
        AttachmentDraft(
          localKey: _ids.next(),
          pendingPath: draft.imagePath,
          displayName: 'vaccination_card_scan.jpg',
          caption: 'OCR scan',
        ),
      ],
    );

    // Also archive as a medical document linked to the vaccination.
    final doc = await documents.save(
      document: MedicalDocument(
        id: '',
        childId: childId,
        documentType: MedicalDocumentTypes.vaccinationCard,
        title: name,
        documentDate: given,
        vaccinationId: vaccination.id,
        mediaAssetId: '',
        notes: draft.valueOf(OcrFieldKeys.notes),
        createdAt: now,
        updatedAt: now,
      ),
      pendingFilePath: draft.imagePath,
      isDocument: false,
    );

    return OcrConfirmResult(
      scanType: OcrScanType.vaccinationCard,
      entityId: vaccination.id,
      documentId: doc.id,
    );
  }

  Future<OcrConfirmResult> _savePrescription(
    String childId,
    OcrReviewDraft draft,
  ) async {
    final name = draft.valueOf(OcrFieldKeys.medicineName)?.trim() ?? '';
    if (name.isEmpty) {
      throw const ValidationFailure(message: 'Medicine name is required.');
    }
    final start = _parseDate(draft.valueOf(OcrFieldKeys.startDate));
    final now = DateTime.now().toUtc();
    final medicine = await medicines.save(
      Medicine(
        id: '',
        childId: childId,
        name: name,
        strength: draft.valueOf(OcrFieldKeys.strength),
        dosage: draft.valueOf(OcrFieldKeys.dosage),
        frequencyText: draft.valueOf(OcrFieldKeys.frequency),
        startDate: start,
        prescribedBy: draft.valueOf(OcrFieldKeys.prescribedBy),
        status: MedicineStatuses.active,
        notes: draft.valueOf(OcrFieldKeys.notes) ??
            _rawSnippet(draft.raw.fullText),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final doc = await documents.save(
      document: MedicalDocument(
        id: '',
        childId: childId,
        documentType: MedicalDocumentTypes.prescription,
        title: name,
        documentDate: start,
        mediaAssetId: '',
        notes: draft.valueOf(OcrFieldKeys.notes),
        createdAt: now,
        updatedAt: now,
      ),
      pendingFilePath: draft.imagePath,
      isDocument: false,
    );

    return OcrConfirmResult(
      scanType: OcrScanType.prescription,
      entityId: medicine.id,
      documentId: doc.id,
    );
  }

  Future<OcrConfirmResult> _saveDiagnostic(
    String childId,
    OcrReviewDraft draft,
  ) async {
    final title = draft.valueOf(OcrFieldKeys.documentTitle)?.trim() ??
        'Diagnostic report';
    final date = _parseDate(draft.valueOf(OcrFieldKeys.documentDate));
    final facility = draft.valueOf(OcrFieldKeys.facility);
    final findings = draft.valueOf(OcrFieldKeys.findings);
    final notes = [
      if (facility != null && facility.isNotEmpty) 'Facility: $facility',
      if (findings != null && findings.isNotEmpty) findings,
      if (draft.valueOf(OcrFieldKeys.notes) != null)
        draft.valueOf(OcrFieldKeys.notes)!,
    ].join('\n\n');
    final now = DateTime.now().toUtc();
    final doc = await documents.save(
      document: MedicalDocument(
        id: '',
        childId: childId,
        documentType: MedicalDocumentTypes.diagnosticReport,
        title: title,
        documentDate: date,
        mediaAssetId: '',
        notes: notes.isEmpty ? _rawSnippet(draft.raw.fullText) : notes,
        createdAt: now,
        updatedAt: now,
      ),
      pendingFilePath: draft.imagePath,
      isDocument: false,
    );
    return OcrConfirmResult(
      scanType: OcrScanType.diagnosticReport,
      entityId: doc.id,
      documentId: doc.id,
    );
  }

  String _rawSnippet(String text) {
    final t = text.trim();
    if (t.isEmpty) return '';
    return t.length > 400 ? '${t.substring(0, 400)}…' : t;
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final cleaned = raw.trim();
    final iso = DateTime.tryParse(cleaned);
    if (iso != null) return DateTime(iso.year, iso.month, iso.day);

    final slash = RegExp(r'^(\d{1,2})[\/\-.](\d{1,2})[\/\-.](\d{2,4})$')
        .firstMatch(cleaned);
    if (slash != null) {
      var d = int.parse(slash.group(1)!);
      var m = int.parse(slash.group(2)!);
      var y = int.parse(slash.group(3)!);
      if (y < 100) y += 2000;
      // Prefer DMY for BD locale when day > 12.
      if (d > 12 && m <= 12) {
        return DateTime(y, m, d);
      }
      if (m > 12 && d <= 12) {
        return DateTime(y, d, m);
      }
      return DateTime(y, m, d);
    }

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final named = RegExp(
      r'^(\d{1,2})\s+([A-Za-z]+)\s+(\d{2,4})$',
    ).firstMatch(cleaned);
    if (named != null) {
      final d = int.parse(named.group(1)!);
      final mon = months[named.group(2)!.substring(0, 3).toLowerCase()];
      var y = int.parse(named.group(3)!);
      if (y < 100) y += 2000;
      if (mon != null) return DateTime(y, mon, d);
    }
    return null;
  }
}
