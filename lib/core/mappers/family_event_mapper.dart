import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/family_event.dart';

abstract final class FamilyEventMapper {
  static FamilyEvent toDomain(FamilyEventRow row) {
    return FamilyEvent(
      id: row.id,
      childId: row.childId,
      eventType: row.eventType,
      title: row.title,
      eventDate: row.eventDate,
      locationText: row.locationText,
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

  static FamilyEventsCompanion toCompanion(FamilyEvent event) {
    return FamilyEventsCompanion(
      id: Value(event.id),
      childId: Value(event.childId),
      eventType: Value(event.eventType),
      title: Value(event.title),
      eventDate: Value(event.eventDate),
      locationText: Value(event.locationText),
      story: Value(event.story),
      childReaction: Value(event.childReaction),
      coverAssetId: Value(event.coverAssetId),
      albumId: Value(event.albumId),
      isFavorite: Value(event.isFavorite),
      createdAt: Value(event.createdAt),
      updatedAt: Value(event.updatedAt),
      deletedAt: Value(event.deletedAt),
    );
  }
}
