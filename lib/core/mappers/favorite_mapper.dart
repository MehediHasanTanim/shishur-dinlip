import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';

abstract final class FavoriteMapper {
  static Favorite toDomain(FavoriteRow row) {
    return Favorite(
      id: row.id,
      childId: row.childId,
      category: row.category,
      value: row.value,
      startDate: row.startDate,
      endDate: row.endDate,
      notes: row.notes,
      sourceBirthdayId: row.sourceBirthdayId,
      recordedAge: row.recordedAge,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static FavoritesCompanion toCompanion(Favorite favorite) {
    return FavoritesCompanion(
      id: Value(favorite.id),
      childId: Value(favorite.childId),
      category: Value(favorite.category),
      value: Value(favorite.value),
      startDate: Value(favorite.startDate),
      endDate: Value(favorite.endDate),
      notes: Value(favorite.notes),
      sourceBirthdayId: Value(favorite.sourceBirthdayId),
      recordedAge: Value(favorite.recordedAge),
      createdAt: Value(favorite.createdAt),
      updatedAt: Value(favorite.updatedAt),
      deletedAt: Value(favorite.deletedAt),
    );
  }
}
