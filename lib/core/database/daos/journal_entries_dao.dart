import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/journal_entries_table.dart';

part 'journal_entries_dao.g.dart';

@DriftAccessor(tables: [JournalEntries])
class JournalEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$JournalEntriesDaoMixin {
  JournalEntriesDao(super.db);

  Future<List<JournalEntryRow>> forChild(String childId, {int? limit}) {
    final query = select(journalEntries)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
      ..orderBy([
        (t) => OrderingTerm.desc(t.eventDate),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<JournalEntryRow?> getById(String id) {
    return (select(journalEntries)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(JournalEntriesCompanion companion) {
    return into(journalEntries).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(journalEntries)..where((t) => t.id.equals(id))).write(
      JournalEntriesCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> setFavorite(String id, bool isFavorite, DateTime updatedAt) {
    return (update(journalEntries)..where((t) => t.id.equals(id))).write(
      JournalEntriesCompanion(
        isFavorite: Value(isFavorite),
        updatedAt: Value(updatedAt),
      ),
    );
  }
}
