import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/first_words_table.dart';

part 'first_words_dao.g.dart';

@DriftAccessor(tables: [FirstWords])
class FirstWordsDao extends DatabaseAccessor<AppDatabase>
    with _$FirstWordsDaoMixin {
  FirstWordsDao(super.db);

  Future<List<FirstWordRow>> forChild(String childId, {int? limit}) {
    final query = select(firstWords)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<FirstWordRow?> getById(String id) {
    return (select(firstWords)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(FirstWordsCompanion companion) {
    return into(firstWords).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(firstWords)..where((t) => t.id.equals(id))).write(
      FirstWordsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }
}
