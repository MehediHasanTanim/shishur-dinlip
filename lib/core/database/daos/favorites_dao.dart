import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/favorites_table.dart';

part 'favorites_dao.g.dart';

@DriftAccessor(tables: [Favorites])
class FavoritesDao extends DatabaseAccessor<AppDatabase>
    with _$FavoritesDaoMixin {
  FavoritesDao(super.db);

  Future<List<FavoriteRow>> forChild(String childId, {String? category}) {
    final query = select(favorites)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.asc(t.category),
        (t) => OrderingTerm.desc(t.startDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (category != null) {
      query.where((t) => t.category.equals(category));
    }
    return query.get();
  }

  Future<FavoriteRow?> getById(String id) {
    return (select(favorites)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  /// Current favorite = no end date (or end in the future).
  Future<FavoriteRow?> currentForCategory(String childId, String category) {
    return (select(favorites)
          ..where(
            (t) =>
                t.childId.equals(childId) &
                t.category.equals(category) &
                t.deletedAt.isNull() &
                t.endDate.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(FavoritesCompanion companion) {
    return into(favorites).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(favorites)..where((t) => t.id.equals(id))).write(
      FavoritesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
