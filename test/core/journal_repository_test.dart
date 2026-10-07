import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/achievements_repository.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/funny_moments_repository.dart';
import 'package:shishur_dinlipi/core/repository/journal_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';

void main() {
  late AppDatabase db;
  late Directory root;
  late JournalRepository journals;
  late FunnyMomentsRepository funny;
  late AchievementsRepository achievements;
  late AttachmentRepository attachments;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_journal_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    final media = MediaService(db, storage: storage);
    attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    final tags = DriftTagsRepository(db);
    journals = DriftJournalRepository(db, attachments: attachments, tags: tags);
    funny = DriftFunnyMomentsRepository(db, attachments: attachments);
    achievements = DriftAchievementsRepository(db, attachments: attachments);

    final children = DriftChildrenRepository(db);
    final now = DateTime.now().toUtc();
    final child = await children.save(
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

  test('saves journal with tags favorite and soft delete', () async {
    final now = DateTime.now().toUtc();
    final saved = await journals.save(
      entry: JournalEntry(
        id: '',
        childId: childId,
        entryType: JournalEntryTypes.proudMoment,
        title: 'প্রথম হাসি 😊',
        body: 'আজ অনেকক্ষণ হাসছিল। একটি দীর্ঘ বাংলা গল্প।',
        eventDate: DateTime(2024, 5, 1),
        mood: JournalMoods.happy,
        isFavorite: true,
        createdAt: now,
        updatedAt: now,
      ),
      tagNames: const ['family', 'park'],
      attachments: const [],
    );

    expect(saved.title, contains('হাসি'));
    expect(saved.isFavorite, isTrue);
    expect(saved.tagNames, containsAll(['family', 'park']));

    await journals.setFavorite(saved.id, false);
    final reloaded = await journals.getById(saved.id);
    expect(reloaded!.isFavorite, isFalse);

    await journals.softDelete(saved.id);
    expect(await journals.getById(saved.id), isNull);
  });

  test('attaches multiple photos and reorders', () async {
    final now = DateTime.now().toUtc();
    final a = await _writePng(root, 'a.png', 32, 32);
    final b = await _writePng(root, 'b.png', 40, 40);

    final saved = await journals.save(
      entry: JournalEntry(
        id: '',
        childId: childId,
        entryType: JournalEntryTypes.memory,
        body: 'photo day',
        eventDate: DateTime(2024, 6, 1),
        createdAt: now,
        updatedAt: now,
      ),
      tagNames: const [],
      attachments: [
        AttachmentDraft(localKey: '1', pendingPath: a.path),
        AttachmentDraft(localKey: '2', pendingPath: b.path),
      ],
    );

    final linked = await attachments.forEntity(
      entityType: EntityTypes.journalEntry,
      entityId: saved.id,
    );
    expect(linked, hasLength(2));
    expect(linked.first.sortOrder, 0);
    expect(linked.last.sortOrder, 1);
  });

  test('funny moments and achievements round-trip', () async {
    final now = DateTime.now().toUtc();
    final moment = await funny.save(
      moment: FunnyMoment(
        id: '',
        childId: childId,
        eventDate: DateTime(2024, 7, 1),
        quoteText: 'আমি বড় হয়ে গেছি!',
        story: 'Said after putting on shoes.',
        peoplePresent: 'Ammu, Abbu',
        createdAt: now,
        updatedAt: now,
      ),
      attachments: const [],
    );
    expect(moment.quoteText, contains('বড়'));

    final achievement = await achievements.save(
      achievement: Achievement(
        id: '',
        childId: childId,
        title: 'First medal',
        category: AchievementCategories.sports,
        eventDate: DateTime(2024, 8, 1),
        description: 'Won the race 🏃',
        createdAt: now,
        updatedAt: now,
      ),
      attachments: const [],
    );
    expect(achievement.title, 'First medal');
  });
}

Future<File> _writePng(Directory root, String name, int w, int h) async {
  final image = img.Image(width: w, height: h);
  img.fill(image, color: img.ColorRgb8(100, 150, 200));
  final bytes = Uint8List.fromList(img.encodePng(image));
  final file = File(p.join(root.path, name));
  await file.writeAsBytes(bytes);
  return file;
}
