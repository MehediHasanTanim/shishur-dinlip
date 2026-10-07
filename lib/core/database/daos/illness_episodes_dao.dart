import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/illness_episodes_table.dart';

part 'illness_episodes_dao.g.dart';

@DriftAccessor(tables: [IllnessEpisodes])
class IllnessEpisodesDao extends DatabaseAccessor<AppDatabase>
    with _$IllnessEpisodesDaoMixin {
  IllnessEpisodesDao(super.db);

  Future<List<IllnessEpisodeRow>> forChild(String childId, {int? limit}) {
    final query = select(illnessEpisodes)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.startDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<IllnessEpisodeRow?> getById(String id) {
    return (select(illnessEpisodes)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<IllnessEpisodeRow?> latestForChild(String childId) {
    return (select(illnessEpisodes)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> upsert(IllnessEpisodesCompanion companion) {
    return into(illnessEpisodes).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(illnessEpisodes)..where((t) => t.id.equals(id))).write(
      IllnessEpisodesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
