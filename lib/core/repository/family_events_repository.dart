import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/family_event.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/album_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/family_event_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class FamilyEventsRepository implements Repository {
  Future<List<FamilyEvent>> forChild(
    String childId, {
    String? eventType,
    int? limit,
  });
  Future<FamilyEvent?> getById(String id);
  Future<FamilyEvent> save(FamilyEvent event);
  Future<void> softDelete(String id);
  Future<Album> ensureFamilyEventAlbum(
    FamilyEvent event, {
    String? childName,
  });
}

class DriftFamilyEventsRepository extends RepositoryBase
    implements FamilyEventsRepository {
  DriftFamilyEventsRepository(super.db);

  @override
  Future<List<FamilyEvent>> forChild(
    String childId, {
    String? eventType,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.familyEventsDao.forChild(
        childId,
        eventType: eventType,
        limit: limit,
      );
      return rows.map(FamilyEventMapper.toDomain).toList();
    }, operation: 'familyEvents.forChild');
  }

  @override
  Future<FamilyEvent?> getById(String id) {
    return guard(() async {
      final row = await db.familyEventsDao.getById(id);
      return row == null ? null : FamilyEventMapper.toDomain(row);
    }, operation: 'familyEvents.getById');
  }

  @override
  Future<FamilyEvent> save(FamilyEvent event) {
    return guard(() async {
      if (event.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Title is required.');
      }
      if (!FamilyEventTypes.all.contains(event.eventType)) {
        throw const ValidationFailure(message: 'Invalid family event type.');
      }
      final nowUtc = now();
      final id = event.id.isEmpty ? ids.next() : event.id;
      final existing = await db.familyEventsDao.getById(id);
      final toSave = event.copyWith(
        id: id,
        title: event.title.trim(),
        locationText: event.locationText?.trim(),
        clearLocationText: event.locationText?.trim().isEmpty ?? true,
        story: event.story?.trim(),
        clearStory: event.story?.trim().isEmpty ?? true,
        childReaction: event.childReaction?.trim(),
        clearChildReaction: event.childReaction?.trim().isEmpty ?? true,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.familyEventsDao.upsert(FamilyEventMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'familyEvents.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.familyEventsDao.softDelete(id, now());
    }, operation: 'familyEvents.softDelete');
  }

  @override
  Future<Album> ensureFamilyEventAlbum(
    FamilyEvent event, {
    String? childName,
  }) {
    return guard(() async {
      if (event.albumId != null) {
        final existing = await db.albumsDao.getById(event.albumId!);
        if (existing != null && existing.deletedAt == null) {
          final items = await db.albumsDao.itemsForAlbum(existing.id);
          return AlbumMapper.toDomain(
            existing,
            items: items.map(AlbumMapper.itemToDomain).toList(),
          );
        }
      }
      final nowUtc = now();
      final albumId = ids.next();
      final prefix = (childName?.trim().isNotEmpty ?? false)
          ? '${childName!.trim()} — '
          : '';
      final album = Album(
        id: albumId,
        childId: event.childId,
        albumType: AlbumTypes.familyEvent,
        title: '$prefix${event.title}',
        startDate: event.eventDate,
        endDate: event.eventDate,
        coverAssetId: event.coverAssetId,
        theme: AlbumThemes.colorful,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );
      await db.albumsDao.upsert(AlbumMapper.toCompanion(album));
      await db.familyEventsDao.upsert(
        FamilyEventMapper.toCompanion(
          event.copyWith(albumId: albumId, updatedAt: nowUtc),
        ),
      );
      return album;
    }, operation: 'familyEvents.ensureFamilyEventAlbum');
  }
}
