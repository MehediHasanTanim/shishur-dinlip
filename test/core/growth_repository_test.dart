import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/first_word.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/first_words_repository.dart';
import 'package:shishur_dinlipi/core/repository/growth_repository.dart';
import 'package:shishur_dinlipi/core/repository/milestones_repository.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'dart:io';

void main() {
  late AppDatabase db;
  late Directory root;
  late GrowthRepository growth;
  late MilestonesRepository milestones;
  late FirstWordsRepository firstWords;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_growth_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    final media = MediaService(db, storage: storage);
    final attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    growth = DriftGrowthRepository(db);
    milestones = DriftMilestonesRepository(db, attachments: attachments);
    firstWords = DriftFirstWordsRepository(db);

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2020, 1, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('growth history deltas and future date validation', () async {
    final now = DateTime.now().toUtc();
    await growth.save(
      GrowthRecord(
        id: '',
        childId: childId,
        measuredAt: DateTime(2024, 1, 1),
        heightCm: 80,
        weightKg: 10,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await growth.save(
      GrowthRecord(
        id: '',
        childId: childId,
        measuredAt: DateTime(2024, 6, 1),
        heightCm: 85,
        weightKg: 11,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final history = await growth.historyForChild(childId);
    expect(history, hasLength(2));
    expect(history.first.heightDeltaCm, closeTo(5, 0.01));
    expect(history.first.weightDeltaKg, closeTo(1, 0.01));

    expect(
      () => growth.save(
        GrowthRecord(
          id: '',
          childId: childId,
          measuredAt: DateTime.now().add(const Duration(days: 2)),
          heightCm: 90,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );

    expect(
      () => growth.save(
        GrowthRecord(
          id: '',
          childId: childId,
          measuredAt: DateTime(2024, 7, 1),
          heightCm: -1,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('many growth points and milestones approximate dates', () async {
    final now = DateTime.now().toUtc();
    for (var i = 0; i < 12; i++) {
      await growth.save(
        GrowthRecord(
          id: '',
          childId: childId,
          measuredAt: DateTime(2023, 1 + (i % 12), 1 + i),
          heightCm: 70 + i.toDouble(),
          weightKg: 8 + i * 0.3,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    expect(await growth.forChild(childId), hasLength(12));

    final milestone = await milestones.save(
      milestone: Milestone(
        id: '',
        childId: childId,
        category: MilestoneCategories.movement,
        title: 'First crawl',
        eventDate: DateTime(2021, 5, 20),
        datePrecision: DatePrecision.month,
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(milestone.eventDate, DateTime(2021, 5, 1));
    expect(milestone.datePrecision, DatePrecision.month);

    final word = await firstWords.save(
      FirstWord(
        id: '',
        childId: childId,
        word: 'আম্মু',
        languageCode: 'bn',
        eventDate: DateTime(2021, 8, 1),
        datePrecision: DatePrecision.approximate,
        audioPlaceholder: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(word.word, 'আম্মু');
    expect(word.audioPlaceholder, isTrue);
  });
}
