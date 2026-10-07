import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/funny_moments_table.dart';

part 'funny_moments_dao.g.dart';

@DriftAccessor(tables: [FunnyMoments])
class FunnyMomentsDao extends DatabaseAccessor<AppDatabase>
    with _$FunnyMomentsDaoMixin {
  FunnyMomentsDao(super.db);

  Future<List<FunnyMomentRow>> forChild(String childId, {int? limit}) {
    final query = select(funnyMoments)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<FunnyMomentRow?> getById(String id) {
    return (select(funnyMoments)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(FunnyMomentsCompanion companion) {
    return into(funnyMoments).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(funnyMoments)..where((t) => t.id.equals(id))).write(
      FunnyMomentsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> setFavorite(String id, bool isFavorite, DateTime updatedAt) {
    return (update(funnyMoments)..where((t) => t.id.equals(id))).write(
      FunnyMomentsCompanion(
        isFavorite: Value(isFavorite),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
