import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/core/mappers/journal_entry_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';

abstract interface class JournalRepository implements Repository {
  Future<List<JournalEntry>> forChild(String childId, {int? limit});
  Future<JournalEntry?> getById(String id);
  Future<JournalEntry> save({
    required JournalEntry entry,
    required List<String> tagNames,
    required List<AttachmentDraft> attachments,
  });
  Future<void> softDelete(String id);
  Future<void> setFavorite(String id, bool isFavorite);
}

class DriftJournalRepository extends RepositoryBase
    implements JournalRepository {
  DriftJournalRepository(
    super.db, {
    required this.attachments,
    required this.tags,
  });

  final AttachmentRepository attachments;
  final TagsRepository tags;

  @override
  Future<List<JournalEntry>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.journalEntriesDao.forChild(childId, limit: limit);
      final result = <JournalEntry>[];
      for (final row in rows) {
        final tagNames = await tags.namesForEntity(
          entityType: EntityTypes.journalEntry,
          entityId: row.id,
        );
        result.add(JournalEntryMapper.toDomain(row, tagNames: tagNames));
      }
      return result;
    }, operation: 'journal.forChild');
  }

  @override
  Future<JournalEntry?> getById(String id) {
    return guard(() async {
      final row = await db.journalEntriesDao.getById(id);
      if (row == null) return null;
      final tagNames = await tags.namesForEntity(
        entityType: EntityTypes.journalEntry,
        entityId: row.id,
      );
      return JournalEntryMapper.toDomain(row, tagNames: tagNames);
    }, operation: 'journal.getById');
  }

  @override
  Future<JournalEntry> save({
    required JournalEntry entry,
    required List<String> tagNames,
    required List<AttachmentDraft> attachments,
  }) {
    return guard(() async {
      final nowUtc = now();
      final id = entry.id.isEmpty ? ids.next() : entry.id;
      final existing = await db.journalEntriesDao.getById(id);
      final toSave = entry.copyWith(
        id: id,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.journalEntriesDao.upsert(
          JournalEntryMapper.toCompanion(toSave),
        );
        await tags.replaceForEntity(
          entityType: EntityTypes.journalEntry,
          entityId: id,
          names: tagNames,
        );
        await this.attachments.syncForEntity(
          entityType: EntityTypes.journalEntry,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });

      return toSave.copyWith(tagNames: tagNames);
    }, operation: 'journal.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.journalEntriesDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.journalEntry,
          entityId: id,
        );
        await tags.replaceForEntity(
          entityType: EntityTypes.journalEntry,
          entityId: id,
          names: const [],
        );
      });
    }, operation: 'journal.softDelete');
  }

  @override
  Future<void> setFavorite(String id, bool isFavorite) {
    return guard(() async {
      await db.journalEntriesDao.setFavorite(id, isFavorite, now());
    }, operation: 'journal.setFavorite');
  }
}
