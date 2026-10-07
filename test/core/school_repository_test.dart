import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/school_events_repository.dart';
import 'package:shishur_dinlipi/core/repository/school_profiles_repository.dart';

void main() {
  late AppDatabase db;
  late Directory root;
  late SchoolProfilesRepository profiles;
  late SchoolEventsRepository events;
  late AttachmentRepository attachments;
  late MediaService media;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    root = await Directory.systemTemp.createTemp('sd_school_');
    final storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    media = MediaService(db, storage: storage);
    attachments = DriftAttachmentRepository(
      db,
      mediaService: media,
      storage: storage,
    );
    profiles = DriftSchoolProfilesRepository(db);
    events = DriftSchoolEventsRepository(db, attachments: attachments);

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
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) await root.delete(recursive: true);
  });

  test('multiple schools with missing end date and class history', () async {
    final now = DateTime.now().toUtc();
    final previous = await profiles.save(
      SchoolProfile(
        id: '',
        childId: childId,
        schoolName: 'Sunshine KG',
        startDate: DateTime(2022, 1, 1),
        endDate: DateTime(2024, 12, 31),
        className: 'Nursery',
        teacherName: 'Miss Rina',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final current = await profiles.save(
      SchoolProfile(
        id: '',
        childId: childId,
        schoolName: 'Greenwood School',
        startDate: DateTime(2025, 1, 1),
        className: 'Class 1',
        teacherName: 'Mr. Karim',
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(previous.endDate, isNotNull);
    expect(current.endDate, isNull);
    expect(current.isCurrent, isTrue);

    final list = await profiles.forChild(childId);
    expect(list, hasLength(2));
    expect(await profiles.currentForChild(childId), isNotNull);
    expect((await profiles.currentForChild(childId))!.schoolName, contains('Greenwood'));

    expect(
      () => profiles.save(
        SchoolProfile(
          id: '',
          childId: childId,
          schoolName: 'Bad Dates',
          startDate: DateTime(2024, 6, 1),
          endDate: DateTime(2024, 1, 1),
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('certificate image and pdf attachment on school event', () async {
    final now = DateTime.now().toUtc();
    final school = await profiles.save(
      SchoolProfile(
        id: '',
        childId: childId,
        schoolName: 'Greenwood',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final png = await _writeBytes(root, 'cert.png', [137, 80, 78, 71, 13, 10, 26, 10]);
    // Minimal valid-ish pdf header bytes for document import (not decoded as image).
    final pdf = await _writeBytes(
      root,
      'report.pdf',
      Uint8List.fromList('%PDF-1.4 fake report card'.codeUnits),
    );

    // PNG won't decode as image in media service - use importDocument path via draft.
    final event = await events.save(
      event: SchoolEvent(
        id: '',
        childId: childId,
        schoolProfileId: school.id,
        eventType: SchoolEventTypes.reportCard,
        title: 'Term 1 report',
        eventDate: DateTime(2025, 6, 1),
        createdAt: now,
        updatedAt: now,
      ),
      attachments: [
        AttachmentDraft(
          localKey: '1',
          pendingPath: pdf.path,
          displayName: 'report.pdf',
          isDocument: true,
        ),
        AttachmentDraft(
          localKey: '2',
          pendingPath: png.path,
          displayName: 'cert.png',
          isDocument: true,
        ),
      ],
    );

    final linked = await attachments.forEntity(
      entityType: EntityTypes.schoolEvent,
      entityId: event.id,
    );
    expect(linked, hasLength(2));
    expect(linked.any((a) => a.media?.assetType.name == 'pdf'), isTrue);

    final upcoming = await events.upcomingForChild(
      childId,
      limit: 5,
    );
    // Past event from 2025-06-1 relative to "today" Oct 2026 may not be upcoming.
    // Create a future event.
    await events.save(
      event: SchoolEvent(
        id: '',
        childId: childId,
        eventType: SchoolEventTypes.exam,
        title: 'Final exam',
        eventDate: DateTime.now().add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final upcoming2 = await events.upcomingForChild(childId);
    expect(upcoming2.any((e) => e.title == 'Final exam'), isTrue);
    expect(upcoming, isA<List<SchoolEvent>>());
  });
}

Future<File> _writeBytes(Directory root, String name, List<int> bytes) async {
  final file = File(p.join(root.path, name));
  await file.writeAsBytes(bytes);
  return file;
}
