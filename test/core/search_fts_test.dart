import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';
import 'package:shishur_dinlipi/core/search/search_highlight.dart';
import 'package:shishur_dinlipi/core/search/search_index_rebuild_service.dart';
import 'package:shishur_dinlipi/core/search/search_index_schema.dart';
import 'package:shishur_dinlipi/core/search/search_service.dart';

void main() {
  late AppDatabase db;
  late String childId;
  late SearchService search;
  late SearchIndexRebuildService index;
  late TagsRepository tags;

  setUp(() async {
    db = AppDatabase.memory();
    index = SearchIndexRebuildService(db);
    search = SearchService(db, index: index);
    tags = DriftTagsRepository(db);

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

    final journalId = idGenerator.next();
    await db.journalEntriesDao.upsert(
      JournalEntriesCompanion.insert(
        id: journalId,
        childId: childId,
        entryType: JournalEntryTypes.memory,
        title: const Value('Park day'),
        body: 'Fun at the park with বাবা near the lake',
        eventDate: DateTime(2024, 6, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await tags.addTag(
      entityType: EntityTypes.journalEntry,
      entityId: journalId,
      name: 'Outdoor',
    );

    await db.milestonesDao.upsert(
      MilestonesCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        category: 'speech',
        title: 'Said আম্মু',
        datePrecision: 'exact',
        createdAt: now,
        updatedAt: now,
        eventDate: Value(DateTime(2023, 3, 1)),
        description: const Value('First clear word'),
      ),
    );

    await db.achievementsDao.upsert(
      AchievementsCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        title: 'Drawing prize',
        category: 'arts',
        eventDate: DateTime(2025, 1, 10),
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('schema v12 creates FTS search_index', () async {
    expect(AppDatabase.currentSchemaVersion, 12);
    await index.ensureSchema();
    final tables = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE name IN ('search_index', 'search_index_meta')",
    ).get();
    final names = tables.map((r) => r.data['name'] as String).toSet();
    expect(names.contains(SearchIndexSchema.tableName), isTrue);
    expect(names.contains(SearchIndexSchema.metaTableName), isTrue);
  });

  test('rebuild indexes documents and supports FTS query', () async {
    final report = await index.rebuildAll();
    expect(report.documentCount, greaterThanOrEqualTo(3));
    expect(await index.documentCount(), report.documentCount);

    final en = await search.search(
      SearchQuery(text: 'Park', childId: childId),
    );
    expect(en.any((r) => r.type == SearchResultType.journal), isTrue);
    expect(
      en.firstWhere((r) => r.type == SearchResultType.journal).highlightedTitle,
      contains(SearchHighlightMarkers.start),
    );

    final bn = await search.search(
      SearchQuery(text: 'আম্মু', childId: childId),
    );
    expect(bn.any((r) => r.type == SearchResultType.milestone), isTrue);
  });

  test('filters by type, date range, and tag', () async {
    await index.rebuildAll();

    final typed = await search.search(
      SearchQuery(
        text: 'prize',
        childId: childId,
        type: SearchResultType.achievement,
      ),
    );
    expect(typed, hasLength(1));

    final dated = await search.search(
      SearchQuery(
        text: 'park',
        childId: childId,
        fromDate: DateTime(2024, 1, 1),
        toDate: DateTime(2024, 12, 31),
      ),
    );
    expect(dated, hasLength(1));

    final outOfRange = await search.search(
      SearchQuery(
        text: 'park',
        childId: childId,
        fromDate: DateTime(2020, 1, 1),
        toDate: DateTime(2020, 12, 31),
      ),
    );
    expect(outOfRange, isEmpty);

    final tagged = await search.search(
      SearchQuery(text: 'park', childId: childId, tag: 'Outdoor'),
    );
    expect(tagged, hasLength(1));

    final tagOnly = await search.search(
      SearchQuery(text: '', childId: childId, tag: 'Outdoor'),
    );
    expect(tagOnly, hasLength(1));

    final wrongTag = await search.search(
      SearchQuery(text: 'park', childId: childId, tag: 'School'),
    );
    expect(wrongTag, isEmpty);
  });

  test('search performance benchmark under budget', () async {
    final now = DateTime.now().toUtc();
    for (var i = 0; i < 400; i++) {
      await db.journalEntriesDao.upsert(
        JournalEntriesCompanion.insert(
          id: idGenerator.next(),
          childId: childId,
          entryType: JournalEntryTypes.memory,
          title: Value('Memory $i'),
          body: 'alpha beta gamma lake park word $i',
          eventDate: DateTime(2022, 1, 1).add(Duration(days: i % 365)),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    final rebuildSw = Stopwatch()..start();
    final report = await index.rebuildAll();
    rebuildSw.stop();

    final searchSw = Stopwatch()..start();
    final page = await search.search(
      SearchQuery(text: 'alpha park', childId: childId, limit: 50),
    );
    searchSw.stop();

    expect(report.documentCount, greaterThanOrEqualTo(400));
    expect(page.length, lessThanOrEqualTo(50));
    // Family-scale budgets: rebuild < 3s, query < 500ms on CI/dev machines.
    expect(rebuildSw.elapsedMilliseconds, lessThan(3000));
    expect(searchSw.elapsedMilliseconds, lessThan(1500));
  }, timeout: const Timeout(Duration(seconds: 30)));
}
