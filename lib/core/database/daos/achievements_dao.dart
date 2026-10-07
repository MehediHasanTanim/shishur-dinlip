import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/achievements_table.dart';

part 'achievements_dao.g.dart';

@DriftAccessor(tables: [Achievements])
class AchievementsDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementsDaoMixin {
  AchievementsDao(super.db);

  Future<List<AchievementRow>> forChild(String childId, {int? limit}) {
    final query = select(achievements)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<AchievementRow?> getById(String id) {
    return (select(achievements)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(AchievementsCompanion companion) {
    return into(achievements).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(achievements)..where((t) => t.id.equals(id))).write(
      AchievementsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> setFavorite(String id, bool isFavorite, DateTime updatedAt) {
    return (update(achievements)..where((t) => t.id.equals(id))).write(
      AchievementsCompanion(
        isFavorite: Value(isFavorite),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
