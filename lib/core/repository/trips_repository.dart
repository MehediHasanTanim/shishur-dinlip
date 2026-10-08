import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/album_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/trip_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class TripsRepository implements Repository {
  Future<List<Trip>> forChild(String childId, {String? tripType, int? limit});
  Future<Trip?> getById(String id);
  Future<Trip> save(Trip trip);
  Future<void> softDelete(String id);
  Future<Album> ensureTripAlbum(Trip trip, {String? childName});
}

class DriftTripsRepository extends RepositoryBase implements TripsRepository {
  DriftTripsRepository(super.db);

  @override
  Future<List<Trip>> forChild(
    String childId, {
    String? tripType,
    int? limit,
  }) {
    return guard(() async {
      final rows = await db.tripsDao.forChild(
        childId,
        tripType: tripType,
        limit: limit,
      );
      return rows.map(TripMapper.toDomain).toList();
    }, operation: 'trips.forChild');
  }

  @override
  Future<Trip?> getById(String id) {
    return guard(() async {
      final row = await db.tripsDao.getById(id);
      return row == null ? null : TripMapper.toDomain(row);
    }, operation: 'trips.getById');
  }

  @override
  Future<Trip> save(Trip trip) {
    return guard(() async {
      if (trip.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Title is required.');
      }
      if (trip.placeName.trim().isEmpty) {
        throw const ValidationFailure(message: 'Place is required.');
      }
      if (!TripTypes.all.contains(trip.tripType)) {
        throw const ValidationFailure(message: 'Invalid trip type.');
      }
      final nowUtc = now();
      final id = trip.id.isEmpty ? ids.next() : trip.id;
      final existing = await db.tripsDao.getById(id);
      final toSave = trip.copyWith(
        id: id,
        title: trip.title.trim(),
        placeName: trip.placeName.trim(),
        story: trip.story?.trim(),
        clearStory: trip.story?.trim().isEmpty ?? true,
        childReaction: trip.childReaction?.trim(),
        clearChildReaction: trip.childReaction?.trim().isEmpty ?? true,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.tripsDao.upsert(TripMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'trips.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.tripsDao.softDelete(id, now());
    }, operation: 'trips.softDelete');
  }

  @override
  Future<Album> ensureTripAlbum(Trip trip, {String? childName}) {
    return guard(() async {
      if (trip.albumId != null) {
        final existing = await db.albumsDao.getById(trip.albumId!);
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
        childId: trip.childId,
        albumType: AlbumTypes.trip,
        title: '$prefix${trip.title}',
        startDate: trip.startDate,
        endDate: trip.endDate ?? trip.startDate,
        coverAssetId: trip.coverAssetId,
        theme: AlbumThemes.playful,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );
      await db.albumsDao.upsert(AlbumMapper.toCompanion(album));
      await db.tripsDao.upsert(
        TripMapper.toCompanion(
          trip.copyWith(albumId: albumId, updatedAt: nowUtc),
        ),
      );
      return album;
    }, operation: 'trips.ensureTripAlbum');
  }
}
