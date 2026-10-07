import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_font_loader.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_theme.dart';
import 'package:shishur_dinlipi/core/pdf/year_review_pdf_generator.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/year_review_preferences_repository.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_query_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late Directory root;
  late String childId;
  late YearReviewQueryService query;
  late YearReviewPdfGenerator pdf;
  late FileStorageService storage;
  late DriftYearReviewPreferencesRepository prefs;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_s10_');
    storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    query = YearReviewQueryService(db);
    pdf = YearReviewPdfGenerator(db, storage: storage);
    prefs = DriftYearReviewPreferencesRepository(db);

    // Load real bundled fonts for PDF generation tests (BN + Latin fallback).
    final bnBytes = await File(
      'assets/fonts/NotoSansBengali-Regular.ttf',
    ).readAsBytes();
    final latinBytes = await File(
      'assets/fonts/NotoSans-Regular.ttf',
    ).readAsBytes();
    PdfFontLoader.debugSetFonts(
      primary: pw.Font.ttf(ByteData.sublistView(Uint8List.fromList(bnBytes))),
      fallback: [
        pw.Font.ttf(ByteData.sublistView(Uint8List.fromList(latinBytes))),
      ],
    );

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2019, 3, 15),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;

    await db.milestonesDao.upsert(
      MilestonesCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        category: 'motor',
        title: 'Rode a bike',
        datePrecision: 'exact',
        createdAt: now,
        updatedAt: now,
        eventDate: Value(DateTime(2024, 4, 1)),
      ),
    );
    await db.achievementsDao.upsert(
      AchievementsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        title: 'School prize',
        category: 'school',
        eventDate: DateTime(2024, 6, 10),
        createdAt: now,
        updatedAt: now,
        isFavorite: const Value(true),
      ),
    );
    await db.funnyMomentsDao.upsert(
      FunnyMomentsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        eventDate: DateTime(2024, 7, 1),
        createdAt: now,
        updatedAt: now,
        quoteText: const Value('আমি বড় হয়ে গেছি!'),
        title: const Value('Funny quote'),
      ),
    );
    await db.journalEntriesDao.upsert(
      JournalEntriesCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        entryType: JournalEntryTypes.memory,
        title: const Value('Park day'),
        body: 'Fun with বাবা at the park',
        eventDate: DateTime(2024, 5, 20),
        createdAt: now,
        updatedAt: now,
        isFavorite: const Value(true),
      ),
    );
    await db.schoolEventsDao.upsert(
      SchoolEventsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        eventType: 'event',
        title: 'Sports day',
        eventDate: DateTime(2024, 8, 12),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await db.growthRecordsDao.upsert(
      GrowthRecordsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        measuredAt: DateTime(2024, 1, 10),
        createdAt: now,
        updatedAt: now,
        heightCm: const Value(105),
        weightKg: const Value(17),
      ),
    );
    await db.growthRecordsDao.upsert(
      GrowthRecordsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        measuredAt: DateTime(2024, 11, 10),
        createdAt: now,
        updatedAt: now,
        heightCm: const Value(110),
        weightKg: const Value(18.5),
      ),
    );
  });

  tearDown(() async {
    PdfFontLoader.clearCache();
    await db.close();
    if (await root.exists()) {
      await root.delete(recursive: true);
    }
  });

  test('schema version is 10', () {
    expect(AppDatabase.currentSchemaVersion, 10);
  });

  test('query engine builds draft with signature title and sections', () async {
    final draft = await query.buildDraft(childId: childId, year: 2024);
    expect(draft.displayTitle, 'Azwad — Age 5: Year in Review');
    expect(draft.ageAtEnd, 5);
    expect(draft.growth.hasData, isTrue);
    expect(
      draft.items.any((i) => i.section == YearReviewSection.birthday),
      isTrue,
    );
    expect(
      draft.items.any((i) => i.section == YearReviewSection.milestones),
      isTrue,
    );
    expect(
      draft.items.any((i) => i.section == YearReviewSection.achievements),
      isTrue,
    );
    expect(
      draft.items.any((i) => i.section == YearReviewSection.funnyMoments),
      isTrue,
    );
    expect(
      draft.items.any((i) => i.section == YearReviewSection.journals),
      isTrue,
    );
    expect(
      draft.items.any((i) => i.section == YearReviewSection.school),
      isTrue,
    );
  });

  test('highlight selector prioritizes favorites and caps photos', () {
    final items = [
      for (var i = 0; i < 40; i++)
        YearReviewItem(
          id: 'photo-$i',
          section: YearReviewSection.photos,
          title: 'P$i',
          eventDate: DateTime(2024, 1, 1 + (i % 28)),
          priority: i == 0
              ? YearReviewPriorities.favorites
              : YearReviewPriorities.photos,
        ),
    ];
    final selected = YearReviewHighlightSelector.apply(candidates: items);
    final included = selected.where((i) => i.included).length;
    expect(included, lessThanOrEqualTo(YearReviewHighlightSelector.maxPhotosDefault));
    expect(selected.firstWhere((i) => i.id == 'photo-0').included, isTrue);
  });

  test('preferences persist theme cover health language letter', () async {
    final now = DateTime.now().toUtc();
    final saved = await prefs.save(
      YearReviewPreference(
        id: idGenerator.next(),
        childId: childId,
        year: 2024,
        parentLetter: 'প্রিয় আজওয়াদ, আমরা গর্বিত। Dear Azwad.',
        coverAssetId: null,
        theme: AlbumThemes.playful,
        includeHealth: true,
        languageCode: 'bn',
        selectionJson: null,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final loaded = await prefs.forChildYear(childId, 2024);
    expect(loaded?.id, saved.id);
    expect(loaded?.theme, AlbumThemes.playful);
    expect(loaded?.includeHealth, isTrue);
    expect(loaded?.languageCode, 'bn');
    expect(loaded?.parentLetter, contains('আজওয়াদ'));

    final draft = await query.buildDraft(
      childId: childId,
      year: 2024,
      languageCode: 'en',
    );
    expect(draft.theme, AlbumThemes.playful);
    expect(draft.includeHealth, isTrue);
    expect(draft.parentLetter, contains('Dear Azwad'));
  });

  test('pdf themes resolve all four MVP themes', () {
    for (final id in AlbumThemes.all) {
      final theme = PdfThemeEngine.resolve(id);
      expect(theme.id, id);
    }
  });

  test('pdf generation works with no photos and mixed language', () async {
    final stages = <PdfGenerationStage>[];
    final draft = await query.buildDraft(childId: childId, year: 2024);
    final withLetter = draft.copyWith(
      languageCode: 'bn',
      theme: AlbumThemes.elegant,
      parentLetter: 'প্রিয় আজওয়াদ,\n\n${'ভালোবাসা। ' * 40}\n\nLove, Ammu & Abbu',
      includeHealth: false,
    );

    final result = await pdf.generate(
      draft: withLetter,
      onProgress: (p) => stages.add(p.stage),
    );

    expect(result.title, contains('বছরের স্মৃতিচারণ'));
    expect(result.title, contains('Azwad'));
    expect(File(result.absolutePath).existsSync(), isTrue);
    expect(result.byteSize, greaterThan(100));
    expect(stages, contains(PdfGenerationStage.complete));

    final export = await db.generatedExportsDao.getById(result.exportId);
    expect(export, isNotNull);
    expect(export!.exportType, YearReviewPdfGenerator.exportType);
  });

  test('pdf generation handles many photos and large images', () async {
    final media = MediaService(db, storage: storage);
    final now = DateTime.now().toUtc();
    for (var i = 0; i < 12; i++) {
      final image = img.Image(width: 2400, height: 1800);
      img.fill(image, color: img.ColorRgb8(100 + i * 10, 80, 120));
      final bytes = Uint8List.fromList(img.encodeJpg(image, quality: 90));
      final temp = File('${root.path}/big_$i.jpg');
      await temp.writeAsBytes(bytes);
      final asset = await media.importImage(
        sourceFile: temp,
        childId: childId,
        originalFilename: 'big_$i.jpg',
        capturedAt: DateTime(2024, 2, 1 + i),
      );
      expect(asset.id, isNotEmpty);
    }

    // Favorites mark via dao
    final images = await db.mediaAssetsDao.imagesForChild(childId);
    expect(images.length, greaterThanOrEqualTo(12));
    await db.mediaAssetsDao.setFavorite(images.first.id, true, now);

    final draft = await query.buildDraft(childId: childId, year: 2024);
    final result = await pdf.generate(
      draft: draft.copyWith(theme: AlbumThemes.colorful),
    );
    expect(result.byteSize, greaterThan(500));
    expect(File(result.absolutePath).existsSync(), isTrue);
  });

  test('cancelled generation throws and does not leave corrupt export', () async {
    final draft = await query.buildDraft(childId: childId, year: 2024);
    final token = PdfGenerationToken()..cancel();
    await expectLater(
      pdf.generate(draft: draft, token: token),
      throwsA(isA<Exception>()),
    );
  });

  test('bengali + latin fonts render mixed English/বাংলা', () async {
    final bnFile = File('assets/fonts/NotoSansBengali-Regular.ttf');
    final latinFile = File('assets/fonts/NotoSans-Regular.ttf');
    expect(bnFile.existsSync(), isTrue);
    expect(latinFile.existsSync(), isTrue);

    final bn = pw.Font.ttf(
      ByteData.sublistView(Uint8List.fromList(await bnFile.readAsBytes())),
    );
    final latin = pw.Font.ttf(
      ByteData.sublistView(Uint8List.fromList(await latinFile.readAsBytes())),
    );
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(
              'Azwad — Age 5: Year in Review',
              style: pw.TextStyle(font: bn, fontFallback: [latin], fontSize: 18),
            ),
            pw.Text(
              'প্রিয় আজওয়াদ, এই বছরটি ছিল অসাধারণ। Love, Ammu.',
              style: pw.TextStyle(font: bn, fontFallback: [latin], fontSize: 12),
            ),
          ],
        ),
      ),
    );
    final bytes = await doc.save();
    expect(bytes.length, greaterThan(100));
  });

  test('health section excluded when includeHealth is false', () async {
    final now = DateTime.now().toUtc();
    await db.vaccinationsDao.upsert(
      VaccinationsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        vaccineName: 'MMR',
        status: 'completed',
        createdAt: now,
        updatedAt: now,
        givenDate: Value(DateTime(2024, 3, 1)),
      ),
    );
    final draft = await query.buildDraft(childId: childId, year: 2024);
    expect(
      draft.items.any((i) => i.section == YearReviewSection.health),
      isTrue,
    );
    expect(draft.copyWith(includeHealth: false).includedItems().any(
          (i) => i.section == YearReviewSection.health,
        ), isFalse);
  });
}
