import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/attachments_table.dart';

part 'attachments_dao.g.dart';

@DriftAccessor(tables: [Attachments])
class AttachmentsDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentsDaoMixin {
  AttachmentsDao(super.db);

  Future<List<AttachmentRow>> forEntity({
    required String entityType,
    required String entityId,
  }) {
    return (select(attachments)
          ..where(
            (t) =>
                t.entityType.equals(entityType) &
                t.entityId.equals(entityId) &
                t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<void> upsert(AttachmentsCompanion companion) {
    return into(attachments).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(attachments)..where((t) => t.id.equals(id))).write(
      AttachmentsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<void> softDeleteForEntity({
    required String entityType,
    required String entityId,
    required DateTime deletedAt,
  }) {
    return (update(attachments)..where(
          (t) =>
              t.entityType.equals(entityType) &
              t.entityId.equals(entityId) &
              t.deletedAt.isNull(),
        ))
        .write(
          AttachmentsCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
          ),
        );
  }

  /// First attachment row per entity (lowest sort order), for timeline thumbs.
  Future<List<AttachmentRow>> firstForEntities({
    required String entityType,
    required List<String> entityIds,
  }) async {
    if (entityIds.isEmpty) return const [];
    final rows = await (select(attachments)
          ..where(
            (t) =>
                t.entityType.equals(entityType) &
                t.entityId.isIn(entityIds) &
                t.deletedAt.isNull(),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.entityId),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
        .get();
    final seen = <String>{};
    final first = <AttachmentRow>[];
    for (final row in rows) {
      if (seen.add(row.entityId)) first.add(row);
    }
    return first;
  }

  Future<Set<String>> entityIdsWithAttachments({
    required String entityType,
    required List<String> entityIds,
  }) async {
    if (entityIds.isEmpty) return {};
    final rows = await (select(attachments)..where(
          (t) =>
              t.entityType.equals(entityType) &
              t.entityId.isIn(entityIds) &
              t.deletedAt.isNull(),
        ))
        .get();
    return rows.map((r) => r.entityId).toSet();
  }
}

