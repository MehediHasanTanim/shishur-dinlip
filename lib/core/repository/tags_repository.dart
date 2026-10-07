import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class TagsRepository implements Repository {
  Future<List<String>> namesForEntity({
    required String entityType,
    required String entityId,
  });

  Future<void> replaceForEntity({
    required String entityType,
    required String entityId,
    required List<String> names,
  });

  Future<List<String>> recentNames({int limit = 20});
}

class DriftTagsRepository extends RepositoryBase implements TagsRepository {
  DriftTagsRepository(super.db);

  @override
  Future<List<String>> namesForEntity({
    required String entityType,
    required String entityId,
  }) {
    return guard(() async {
      final tags = await db.tagsDao.tagsForEntity(
        entityType: entityType,
        entityId: entityId,
      );
      return tags.map((t) => t.name).toList()..sort();
    }, operation: 'tags.namesForEntity');
  }

  @override
  Future<void> replaceForEntity({
    required String entityType,
    required String entityId,
    required List<String> names,
  }) {
    return guard(() async {
      final nowUtc = now();
      await db.tagsDao.softDeleteLinksForEntity(
        entityType: entityType,
        entityId: entityId,
        deletedAt: nowUtc,
      );

      final cleaned = names
          .map((n) => n.trim())
          .where((n) => n.isNotEmpty)
          .toSet()
          .toList();

      for (final name in cleaned) {
        var tag = await db.tagsDao.findByName(name);
        if (tag == null) {
          final id = ids.next();
          await db.tagsDao.upsertTag(
            TagsCompanion(
              id: Value(id),
              name: Value(name),
              createdAt: Value(nowUtc),
              updatedAt: Value(nowUtc),
            ),
          );
          tag = await db.tagsDao.findByName(name);
        }
        if (tag == null) continue;
        await db.tagsDao.upsertLink(
          TagLinksCompanion(
            id: Value(ids.next()),
            tagId: Value(tag.id),
            entityType: Value(entityType),
            entityId: Value(entityId),
            createdAt: Value(nowUtc),
            updatedAt: Value(nowUtc),
          ),
        );
      }
    }, operation: 'tags.replaceForEntity');
  }

  @override
  Future<List<String>> recentNames({int limit = 20}) {
    return guard(() async {
      final tags = await db.tagsDao.getActive();
      return tags.take(limit).map((t) => t.name).toList();
    }, operation: 'tags.recent');
  }
}
