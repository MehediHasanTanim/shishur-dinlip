import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/growth_repository.dart';
import 'package:shishur_dinlipi/core/repository/vaccinations_repository.dart';
import 'package:shishur_dinlipi/core/timeline/timeline_service.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;
  late TimelineService timeline;
  late String childId;
  late Directory root;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_timeline_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    final media = MediaService(db, storage: storage);
    final attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    timeline = TimelineService(db);

    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2018, 5, 10),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;

    Future<void> insertJournal({
      required String title,
      required DateTime eventDate,
    }) async {
      final id = idGenerator.next();
      await db.journalEntriesDao.upsert(
        JournalEntriesCompanion.insert(
          id: id,
          childId: childId,
          entryType: JournalEntryTypes.memory,
          body: title,
          eventDate: eventDate,
          createdAt: now,
          updatedAt: now,
          title: Value(title),
        ),
      );
    }

    await insertJournal(title: 'Park', eventDate: DateTime(2024, 5, 10, 9));
    await insertJournal(title: 'Evening', eventDate: DateTime(2024, 5, 10, 18));

    await DriftGrowthRepository(db).save(
      GrowthRecord(
        id: '',
        childId: childId,
        measuredAt: DateTime(2024, 5, 10, 12),
        heightCm: 110,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await DriftVaccinationsRepository(db, attachments: attachments).save(
      vaccination: Vaccination(
        id: '',
        childId: childId,
        vaccineName: 'MMR',
        givenDate: DateTime(2023, 5, 10),
        status: VaccinationStatuses.completed,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('same-day ordering prefers journal before growth', () async {
    final page = await timeline.pageForChild(childId: childId);
    final sameDay = page.items
        .where(
          (i) =>
              i.eventDate.year == 2024 &&
              i.eventDate.month == 5 &&
              i.eventDate.day == 10,
        )
        .toList();
    expect(sameDay.length, greaterThanOrEqualTo(3));
    final types = sameDay.map((i) => i.type).toList();
    expect(
      types.indexOf(TimelineItemType.journal),
      lessThan(types.indexOf(TimelineItemType.growth)),
    );
  });

  test('filters and pagination work', () async {
    final growth = await timeline.pageForChild(
      childId: childId,
      filter: TimelineFilter.growth,
    );
    expect(
      growth.items.every((i) => i.type == TimelineItemType.growth),
      isTrue,
    );

    final health = await timeline.pageForChild(
      childId: childId,
      filter: TimelineFilter.health,
    );
    expect(
      health.items.every(
        (i) =>
            i.type == TimelineItemType.vaccination ||
            i.type == TimelineItemType.illness ||
            i.type == TimelineItemType.doctorVisit,
      ),
      isTrue,
    );

    final page1 = await timeline.pageForChild(
      childId: childId,
      offset: 0,
      limit: 2,
    );
    expect(page1.items, hasLength(2));
    expect(page1.hasMore, isTrue);
    final page2 = await timeline.pageForChild(
      childId: childId,
      offset: 2,
      limit: 2,
    );
    expect(page2.items, isNotEmpty);
    expect(page1.items.first.id, isNot(page2.items.first.id));
  });

  test('on this day matches month/day prior years', () async {
    final items = await timeline.onThisDay(
      childId: childId,
      asOf: DateTime(2026, 5, 10),
    );
    expect(items, isNotEmpty);
    expect(
      items.every((i) => i.eventDate.month == 5 && i.eventDate.day == 10),
      isTrue,
    );
    expect(items.every((i) => i.eventDate.year < 2026), isTrue);
  });

  test('thousands of timeline entries paginate', () async {
    final now = DateTime.now().toUtc();
    final growthRepo = DriftGrowthRepository(db);
    for (var i = 0; i < 1200; i++) {
      await growthRepo.save(
        GrowthRecord(
          id: '',
          childId: childId,
          measuredAt: DateTime(2020, 1, 1).add(Duration(days: i)),
          heightCm: 70 + (i % 50),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    final page = await timeline.pageForChild(
      childId: childId,
      filter: TimelineFilter.growth,
      limit: 50,
    );
    expect(page.totalApprox, greaterThan(1000));
    expect(page.items, hasLength(50));
    expect(page.hasMore, isTrue);

    var loaded = page.items.length;
    var offset = 50;
    while (loaded < 200) {
      final next = await timeline.pageForChild(
        childId: childId,
        filter: TimelineFilter.growth,
        offset: offset,
        limit: 50,
      );
      loaded += next.items.length;
      offset += next.items.length;
      if (!next.hasMore) break;
    }
    expect(loaded, greaterThanOrEqualTo(200));
  });
}
