import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/backup_crypto.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/doctor_visit.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_font_loader.dart';
import 'package:shishur_dinlipi/core/pdf/year_review_pdf_generator.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/doctor_visits_repository.dart';
import 'package:shishur_dinlipi/core/repository/growth_repository.dart';
import 'package:shishur_dinlipi/core/repository/illness_episodes_repository.dart';
import 'package:shishur_dinlipi/core/repository/journal_repository.dart';
import 'package:shishur_dinlipi/core/repository/medicines_repository.dart';
import 'package:shishur_dinlipi/core/repository/milestones_repository.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_query_service.dart';
import 'package:pdf/widgets.dart' as pw;

/// Automated MVP regression path (Sprint 12 §17.7).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late Directory root;
  late FileStorageService storage;
  late String childId;

  setUp(() async {
    AppConfig.initialize(AppFlavor.dev);
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_mvp_');
    storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();

    final bn = await File(
      'assets/fonts/NotoSansBengali-Regular.ttf',
    ).readAsBytes();
    final latin = await File('assets/fonts/NotoSans-Regular.ttf').readAsBytes();
    PdfFontLoader.debugSetFonts(
      primary: pw.Font.ttf(ByteData.sublistView(Uint8List.fromList(bn))),
      fallback: [
        pw.Font.ttf(ByteData.sublistView(Uint8List.fromList(latin))),
      ],
    );

    // Fake DB file for backup snapshot path.
    await File(
      p.join(root.parent.path, 'shishur_dinlipi.sqlite'),
    ).writeAsBytes(List<int>.filled(128, 1));
  });

  tearDown(() async {
    PdfFontLoader.clearCache();
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
    final dbFile = File(p.join(root.parent.path, 'shishur_dinlipi.sqlite'));
    if (await dbFile.exists()) await dbFile.delete();
  });

  test('MVP flow: child → records → PDF → backup decrypt', () async {
    final now = DateTime.now().toUtc();
    final children = DriftChildrenRepository(db);
    final media = MediaService(db, storage: storage);
    final attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    final tags = DriftTagsRepository(db);
    final journals = DriftJournalRepository(
      db,
      attachments: attachments,
      tags: tags,
    );
    final growth = DriftGrowthRepository(db);
    final milestones = DriftMilestonesRepository(db, attachments: attachments);
    final illness = DriftIllnessEpisodesRepository(
      db,
      attachments: attachments,
    );
    final medicines = DriftMedicinesRepository(db);
    final doctors = DriftDoctorVisitsRepository(db, attachments: attachments);

    // 1–2. First launch / create child
    final child = await children.save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2019, 3, 15),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
    expect(child.name, 'Azwad');

    // 3. Add photo
    final image = img.Image(width: 640, height: 480);
    img.fill(image, color: img.ColorRgb8(20, 120, 80));
    final photoFile = File(p.join(root.path, 'memory.jpg'));
    await photoFile.writeAsBytes(img.encodeJpg(image));
    final asset = await media.importImage(
      sourceFile: photoFile,
      childId: childId,
      originalFilename: 'memory.jpg',
      capturedAt: DateTime(2024, 5, 1),
    );
    expect(asset.id, isNotEmpty);

    // 4. Growth
    await growth.save(
      GrowthRecord(
        id: idGenerator.next(),
        childId: childId,
        measuredAt: DateTime(2024, 6, 1),
        heightCm: 110,
        weightKg: 18,
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 5. Milestone
    await milestones.save(
      milestone: Milestone(
        id: idGenerator.next(),
        childId: childId,
        category: 'motor',
        title: 'Rode a bike',
        eventDate: DateTime(2024, 4, 10),
        datePrecision: DatePrecision.exact,
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 6. Journal
    await journals.save(
      entry: JournalEntry(
        id: idGenerator.next(),
        childId: childId,
        entryType: JournalEntryTypes.memory,
        title: 'Park day',
        body: 'Fun with বাবা',
        eventDate: DateTime(2024, 5, 20),
        createdAt: now,
        updatedAt: now,
      ),
      tagNames: const ['park'],
      attachments: const [],
    );

    // 7. Illness
    await illness.save(
      episode: IllnessEpisode(
        id: idGenerator.next(),
        childId: childId,
        title: 'Cold',
        startDate: DateTime(2024, 7, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 8. Medicine
    await medicines.save(
      Medicine(
        id: idGenerator.next(),
        childId: childId,
        name: 'Paracetamol',
        status: MedicineStatuses.active,
        startDate: DateTime(2024, 7, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 9. Doctor visit
    await doctors.save(
      visit: DoctorVisit(
        id: idGenerator.next(),
        childId: childId,
        visitDate: DateTime(2024, 7, 3),
        doctorName: 'Dr. Rahman',
        createdAt: now,
        updatedAt: now,
      ),
    );

    // 10. Generate PDF
    final draft = await YearReviewQueryService(db).buildDraft(
      childId: childId,
      year: 2024,
      languageCode: 'en',
    );
    expect(draft.displayTitle, contains('Year in Review'));
    final pdf = await YearReviewPdfGenerator(db, storage: storage).generate(
      draft: draft.copyWith(
        parentLetter: 'Dear Azwad — প্রিয় আজওয়াদ',
      ),
    );
    expect(File(pdf.absolutePath).existsSync(), isTrue);

    // 11–12. Backup encrypt + decrypt integrity
    final backups = BackupService(db: db, storage: storage);
    final backup = await backups.createBackup(
      password: 'mvp-backup-pass',
      confirmPassword: 'mvp-backup-pass',
    );
    final bytes = await File(backup.absolutePath).readAsBytes();
    final clear = await BackupCrypto.decrypt(
      package: Uint8List.fromList(bytes),
      password: 'mvp-backup-pass',
    );
    expect(clear.length, greaterThan(100));

    // Schema indexes present on fresh DB.
    expect(AppDatabase.currentSchemaVersion, 9);
  });
}
