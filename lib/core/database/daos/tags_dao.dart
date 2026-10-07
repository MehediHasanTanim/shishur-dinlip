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
}
