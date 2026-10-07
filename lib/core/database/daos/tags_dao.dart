import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/tag_links_table.dart';
import 'package:shishur_dinlipi/core/database/tables/tags_table.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [Tags, TagLinks])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<TagRow>> getActive() {
    return (select(tags)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<TagRow?> findByName(String name) {
    return (select(tags)
          ..where((t) => t.name.equals(name) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<TagRow?> findByNameIgnoreCase(String name) async {
    final exact = await findByName(name);
    if (exact != null) return exact;
    final all = await getActive();
    final lower = name.toLowerCase();
    for (final tag in all) {
      if (tag.name.toLowerCase() == lower) return tag;
    }
    return null;
  }

  Future<List<TagLinkRow>> linksForTag(String tagId, {String? entityType}) {
    final query = select(tagLinks)
      ..where((t) => t.tagId.equals(tagId) & t.deletedAt.isNull());
    if (entityType != null) {
      query.where((t) => t.entityType.equals(entityType));
    }
    return query.get();
  }

  Future<void> softDeleteLinkForTagEntity({
    required String tagId,
    required String entityType,
    required String entityId,
    required DateTime deletedAt,
  }) {
    return (update(tagLinks)..where(
          (t) =>
              t.tagId.equals(tagId) &
              t.entityType.equals(entityType) &
              t.entityId.equals(entityId) &
              t.deletedAt.isNull(),
        ))
        .write(
          TagLinksCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
          ),
        );
  }

  Future<void> upsertTag(TagsCompanion companion) {
    return into(tags).insertOnConflictUpdate(companion);
  }

  Future<void> upsertLink(TagLinksCompanion companion) {
    return into(tagLinks).insertOnConflictUpdate(companion);
  }

  Future<List<TagLinkRow>> linksForEntity({
    required String entityType,
    required String entityId,
  }) {
    return (select(tagLinks)..where(
          (t) =>
              t.entityType.equals(entityType) &
              t.entityId.equals(entityId) &
              t.deletedAt.isNull(),
        ))
        .get();
  }

  Future<List<TagRow>> tagsForEntity({
    required String entityType,
    required String entityId,
  }) async {
    final links = await linksForEntity(
      entityType: entityType,
      entityId: entityId,
    );
    if (links.isEmpty) return const [];
    final tagIds = links.map((l) => l.tagId).toList();
    return (select(tags)..where(
          (t) => t.id.isIn(tagIds) & t.deletedAt.isNull(),
        ))
        .get();
  }

  Future<void> softDeleteLinksForEntity({
    required String entityType,
    required String entityId,
    required DateTime deletedAt,
  }) {
    return (update(tagLinks)..where(
          (t) =>
              t.entityType.equals(entityType) &
              t.entityId.equals(entityId) &
              t.deletedAt.isNull(),
        ))
        .write(
          TagLinksCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
          ),
        );
  }
}

