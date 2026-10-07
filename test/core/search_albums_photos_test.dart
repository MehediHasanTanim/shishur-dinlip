import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/photo_library_item.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/photos/photo_library_service.dart';
import 'package:shishur_dinlipi/core/repository/albums_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';
import 'package:shishur_dinlipi/core/search/search_service.dart';

void main() {
  late AppDatabase db;
  late Directory root;
  late String childId;
  late SearchService search;
  late TagsRepository tags;
  late AlbumsRepository albums;
  late PhotoLibraryService photos;
  late MediaService media;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_s9_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    media = MediaService(db, storage: storage);
    search = SearchService(db);
    tags = DriftTagsRepository(db);
    albums = DriftAlbumsRepository(db);
    photos = PhotoLibraryService(db, storage: storage);

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

    await db.journalEntriesDao.upsert(
      JournalEntriesCompanion.insert(
        id: idGenerator.next(),
        childId: childId,
        entryType: JournalEntryTypes.memory,
        title: const Value('Park day'),
        body: 'Fun at the park with বাবা',
        eventDate: DateTime(2024, 6, 1),
        createdAt: now,
        updatedAt: now,
      ),
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
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('English Bengali and mixed-language search', () async {
    final en = await search.search(
      SearchQuery(text: 'Park', childId: childId),
    );
    expect(en.any((r) => r.type == SearchResultType.journal), isTrue);

    final bn = await search.search(
      SearchQuery(text: 'আম্মু', childId: childId),
    );
    expect(bn.any((r) => r.type == SearchResultType.milestone), isTrue);

    final mixed = await search.search(
      SearchQuery(text: 'বাবা', childId: childId),
    );
    expect(mixed, isNotEmpty);

    final typed = await search.search(
      SearchQuery(
        text: 'prize',
        childId: childId,
        type: SearchResultType.achievement,
      ),
    );
    expect(typed, hasLength(1));
  });

  test('large result set is capped', () async {
    final now = DateTime.now().toUtc();
    for (var i = 0; i < 150; i++) {
      await db.journalEntriesDao.upsert(
        JournalEntriesCompanion.insert(
          id: idGenerator.next(),
          childId: childId,
          entryType: JournalEntryTypes.memory,
          title: Value('Memory $i'),
          body: 'alpha beta gamma $i',
          eventDate: DateTime(2022, 1, 1).add(Duration(days: i)),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    final page = await search.search(
      SearchQuery(text: 'alpha', childId: childId, limit: 50),
    );
    expect(page.length, lessThanOrEqualTo(50));
  });

  test('tag duplicates ignored case-insensitively', () async {
    const entityType = EntityTypes.journalEntry;
    const entityId = 'j1';
    final a = await tags.addTag(
      entityType: entityType,
      entityId: entityId,
      name: 'Family',
    );
    final b = await tags.addTag(
      entityType: entityType,
      entityId: entityId,
      name: 'family',
    );
    expect(a.toLowerCase(), b.toLowerCase());
    final names = await tags.namesForEntity(
      entityType: entityType,
      entityId: entityId,
    );
    expect(names.where((n) => n.toLowerCase() == 'family'), hasLength(1));

    await tags.replaceForEntity(
      entityType: entityType,
      entityId: entityId,
      names: const ['Trip', 'trip', 'TRIP', 'Home'],
    );
    final replaced = await tags.namesForEntity(
      entityType: entityType,
      entityId: entityId,
    );
    expect(replaced.length, 2);
  });

  test('album reorder and photo favorite / missing media', () async {
    final now = DateTime.now().toUtc();
    final image = img.Image(width: 32, height: 32);
    img.fill(image, color: img.ColorRgb8(10, 20, 30));
    final bytes = img.encodePng(image);
    final file = File(p.join(root.path, 'p.png'));
    await file.writeAsBytes(bytes);
    final asset = await media.importImage(
      sourceFile: file,
      childId: childId,
      originalFilename: 'p.png',
    );

    final album = await albums.save(
      Album(
        id: '',
        childId: childId,
        albumType: AlbumTypes.custom,
        title: 'Favorites draft',
        theme: AlbumThemes.playful,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final i1 = await albums.addItem(
      albumId: album.id,
      entityType: EntityTypes.mediaAsset,
      entityId: asset.id,
    );
    final i2 = await albums.addItem(
      albumId: album.id,
      entityType: EntityTypes.mediaAsset,
      entityId: 'placeholder-2',
    );
    await albums.reorderItems(album.id, [i2.id, i1.id]);
    final reordered = await albums.getById(album.id);
    expect(reordered!.items.first.id, i2.id);
    expect(reordered.items.last.id, i1.id);

    await photos.setFavorite(asset.id, true);
    final favs = await photos.photosForChild(childId, favoritesOnly: true);
    expect(favs, hasLength(1));

    // Simulate missing media by deleting file.
    final abs = await FileStorageService(rootOverride: root).absoluteFile(
      asset.localPath,
    );
    if (await abs.exists()) await abs.delete();
    final library = await photos.photosForChild(childId);
    expect(library.any((p) => p.fileMissing), isTrue);

    final grouped = await photos.group(
      childId: childId,
      groupBy: PhotoLibraryGroupBy.year,
      dateOfBirth: DateTime(2018, 1, 1),
    );
    expect(grouped.keys, isNotEmpty);
  });
}
