import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
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

  Future<List<String>> allNames();

  Future<String> addTag({
    required String entityType,
    required String entityId,
    required String name,
  });

  Future<void> removeTag({
    required String entityType,
    required String entityId,
    required String name,
  });

  Future<List<({String entityType, String entityId})>> entitiesForTag(
    String name, {
    String? entityType,
  });
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

      final cleaned = <String>[];
      final seenLower = <String>{};
      for (final raw in names) {
        final name = raw.trim();
        if (name.isEmpty) continue;
        final lower = name.toLowerCase();
        if (!seenLower.add(lower)) continue;
        cleaned.add(name);
      }

      for (final name in cleaned) {
        await _linkTag(
          entityType: entityType,
          entityId: entityId,
          name: name,
          nowUtc: nowUtc,
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

  @override
  Future<List<String>> allNames() {
    return guard(() async {
      final tags = await db.tagsDao.getActive();
      return tags.map((t) => t.name).toList();
    }, operation: 'tags.all');
  }

  @override
  Future<String> addTag({
    required String entityType,
    required String entityId,
    required String name,
  }) {
    return guard(() async {
      final cleaned = name.trim();
      if (cleaned.isEmpty) {
        throw const ValidationFailure(message: 'Tag name is required.');
      }
      final existing = await namesForEntity(
        entityType: entityType,
        entityId: entityId,
      );
      final lower = cleaned.toLowerCase();
      final already = existing.any((n) => n.toLowerCase() == lower);
      if (already) {
        return existing.firstWhere((n) => n.toLowerCase() == lower);
      }
      final linked = await _linkTag(
        entityType: entityType,
        entityId: entityId,
        name: cleaned,
        nowUtc: now(),
      );
      return linked;
    }, operation: 'tags.add');
  }

  @override
  Future<void> removeTag({
    required String entityType,
    required String entityId,
    required String name,
  }) {
    return guard(() async {
      final tag = await db.tagsDao.findByNameIgnoreCase(name.trim());
      if (tag == null) return;
      await db.tagsDao.softDeleteLinkForTagEntity(
        tagId: tag.id,
        entityType: entityType,
        entityId: entityId,
        deletedAt: now(),
      );
    }, operation: 'tags.remove');
  }

  @override
  Future<List<({String entityType, String entityId})>> entitiesForTag(
    String name, {
    String? entityType,
  }) {
    return guard(() async {
      final tag = await db.tagsDao.findByNameIgnoreCase(name.trim());
      if (tag == null) return const [];
      final links = await db.tagsDao.linksForTag(
        tag.id,
        entityType: entityType,
      );
      return links
          .map((l) => (entityType: l.entityType, entityId: l.entityId))
          .toList();
    }, operation: 'tags.entitiesForTag');
  }

  Future<String> _linkTag({
    required String entityType,
    required String entityId,
    required String name,
    required DateTime nowUtc,
  }) async {
    var tag = await db.tagsDao.findByNameIgnoreCase(name);
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
      tag = await db.tagsDao.findByNameIgnoreCase(name);
    }
    if (tag == null) {
      throw const DatabaseFailure(message: 'Could not create tag.');
    }
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
    return tag.name;
  }
}
