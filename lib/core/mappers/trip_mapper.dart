import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';

abstract final class TripMapper {
  static Trip toDomain(TripRow row) {
    return Trip(
      id: row.id,
      childId: row.childId,
      tripType: row.tripType,
      title: row.title,
      placeName: row.placeName,
      startDate: row.startDate,
      endDate: row.endDate,
      story: row.story,
      childReaction: row.childReaction,
      coverAssetId: row.coverAssetId,
      albumId: row.albumId,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static TripsCompanion toCompanion(Trip trip) {
    return TripsCompanion(
      id: Value(trip.id),
      childId: Value(trip.childId),
      tripType: Value(trip.tripType),
      title: Value(trip.title),
      placeName: Value(trip.placeName),
      startDate: Value(trip.startDate),
      endDate: Value(trip.endDate),
      story: Value(trip.story),
      childReaction: Value(trip.childReaction),
      coverAssetId: Value(trip.coverAssetId),
      albumId: Value(trip.albumId),
      isFavorite: Value(trip.isFavorite),
      createdAt: Value(trip.createdAt),
      updatedAt: Value(trip.updatedAt),
      deletedAt: Value(trip.deletedAt),
    );
  }
}
