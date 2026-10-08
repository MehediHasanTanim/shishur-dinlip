import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_confirm_service.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_engine.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_field_extractor.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_scan_service.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/medical_documents_repository.dart';
import 'package:shishur_dinlipi/core/repository/medicines_repository.dart';
import 'package:shishur_dinlipi/core/repository/vaccinations_repository.dart';

void main() {
  late Directory root;
  late File imageFile;
  late AppDatabase db;
  late String childId;
  late OcrScanService scan;
  late OcrConfirmService confirm;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('sd_ocr_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    db = AppDatabase.memory();
    final media = MediaService(db, storage: storage);
    final attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2018, 1, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;

    final png = img.Image(width: 16, height: 16);
    img.fill(png, color: img.ColorRgb8(200, 200, 200));
    imageFile = File(p.join(root.path, 'card.png'));
    await imageFile.writeAsBytes(img.encodePng(png));

    scan = OcrScanService(
      engine: FakeOcrEngine(
        scriptedText: '''
Vaccination Card
Vaccine: MMR
Dose: 1st
Date: 15/03/2024
Batch: LOT-7788
Clinic: Dhaka Child Care
''',
      ),
    );
    confirm = OcrConfirmService(
      vaccinations: DriftVaccinationsRepository(db, attachments: attachments),
      medicines: DriftMedicinesRepository(db),
      documents: DriftMedicalDocumentsRepository(db, media: media),
    );
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('extractor finds vaccination fields', () {
    const extractor = OcrFieldExtractor();
    final fields = extractor.extract(
      OcrScanType.vaccinationCard,
      const OcrRawResult(
        fullText: 'MMR Dose: 2nd Date: 01/02/2023 Batch: ABC123 Clinic: City Lab',
      ),
    );
    expect(
      fields.any((f) => f.key == OcrFieldKeys.vaccineName && f.value.contains('MMR')),
      isTrue,
    );
    expect(fields.any((f) => f.key == OcrFieldKeys.batchNumber), isTrue);
    expect(fields.any((f) => f.key == OcrFieldKeys.givenDate), isTrue);
  });

  test('extractor finds prescription and diagnostic fields', () {
    const extractor = OcrFieldExtractor();
    final rx = extractor.extract(
      OcrScanType.prescription,
      const OcrRawResult(
        fullText:
            'Dr. Rahman\nParacetamol 500 mg\nDosage: 5 ml twice daily\nDate: 10/01/2025',
      ),
    );
    expect(rx.any((f) => f.key == OcrFieldKeys.medicineName), isTrue);
    expect(rx.any((f) => f.key == OcrFieldKeys.strength), isTrue);

    final report = extractor.extract(
      OcrScanType.diagnosticReport,
      const OcrRawResult(
        fullText:
            'Complete Blood Count\nLab: Popular Diagnostic\nDate: 05/06/2024\nHemoglobin 12.1',
      ),
    );
    expect(report.any((f) => f.key == OcrFieldKeys.documentTitle), isTrue);
    expect(report.any((f) => f.key == OcrFieldKeys.findings), isTrue);
  });

  test('scan never marks draft confirmed', () async {
    final draft = await scan.scan(
      scanType: OcrScanType.vaccinationCard,
      imageFile: imageFile,
    );
    expect(draft.confirmed, isFalse);
    expect(draft.valueOf(OcrFieldKeys.vaccineName), contains('MMR'));
  });

  test('confirm refuses unconfirmed draft', () async {
    final draft = await scan.scan(
      scanType: OcrScanType.vaccinationCard,
      imageFile: imageFile,
    );
    expect(
      () => confirm.confirmAndSave(childId: childId, draft: draft),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('confirmed vaccination scan saves entity + document', () async {
    final draft = (await scan.scan(
      scanType: OcrScanType.vaccinationCard,
      imageFile: imageFile,
    )).markConfirmed();

    final result = await confirm.confirmAndSave(
      childId: childId,
      draft: draft,
    );
    expect(result.scanType, OcrScanType.vaccinationCard);
    expect(result.entityId, isNotEmpty);
    expect(result.documentId, isNotEmpty);

    final storage2 = FileStorageService(rootOverride: root);
    final media2 = MediaService(db, storage: storage2);
    final vax = await DriftVaccinationsRepository(
      db,
      attachments: DriftAttachmentRepository(
        db,
        mediaService: media2,
        storage: storage2,
      ),
    ).getById(result.entityId);
    expect(vax?.vaccineName, contains('MMR'));

    final docs = await DriftMedicalDocumentsRepository(
      db,
      media: media2,
    ).forChild(childId, documentType: MedicalDocumentTypes.vaccinationCard);
    expect(docs, isNotEmpty);
  });

  test('confirmed prescription and diagnostic save paths', () async {
    final rxScan = OcrScanService(
      engine: FakeOcrEngine(
        scriptedText:
            'Dr. Karim\nAmoxicillin 250 mg\nDosage: 1 tsp thrice daily\nDate: 02/02/2024',
      ),
    );
    final rx = (await rxScan.scan(
      scanType: OcrScanType.prescription,
      imageFile: imageFile,
    )).markConfirmed();
    final rxResult = await confirm.confirmAndSave(childId: childId, draft: rx);
    expect(rxResult.scanType, OcrScanType.prescription);

    final reportScan = OcrScanService(
      engine: FakeOcrEngine(
        scriptedText:
            'CBC\nLab: Ibn Sina\nDate: 03/03/2024\nHemoglobin 11.5\nWBC normal',
      ),
    );
    final report = (await reportScan.scan(
      scanType: OcrScanType.diagnosticReport,
      imageFile: imageFile,
    )).markConfirmed();
    final reportResult =
        await confirm.confirmAndSave(childId: childId, draft: report);
    expect(reportResult.scanType, OcrScanType.diagnosticReport);
    expect(reportResult.documentId, reportResult.entityId);
  });
}
