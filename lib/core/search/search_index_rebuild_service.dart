import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';
import 'package:shishur_dinlipi/core/search/search_index_document.dart';
import 'package:shishur_dinlipi/core/search/search_index_schema.dart';

@immutable
class SearchIndexRebuildReport {
  const SearchIndexRebuildReport({
    required this.documentCount,
    required this.elapsedMs,
  });

  final int documentCount;
  final int elapsedMs;
}

/// Builds and maintains the FTS5 [search_index] virtual table.
class SearchIndexRebuildService extends RepositoryBase {
  SearchIndexRebuildService(super.db);

  Future<void> ensureSchema() {
    return guard(() async {
      await db.customStatement(SearchIndexSchema.createMeta);
      await db.customStatement(SearchIndexSchema.createFts);
    }, operation: 'searchIndex.ensureSchema');
  }

  Future<void> markDirty() {
    return guard(() async {
      await ensureSchema();
      await _setMeta(SearchIndexSchema.metaNeedsRebuild, '1');
    }, operation: 'searchIndex.markDirty');
  }

  Future<bool> needsRebuild() {
    return guard(() async {
      await ensureSchema();
      final flag = await _getMeta(SearchIndexSchema.metaNeedsRebuild);
      if (flag == '1') return true;
      final count = await documentCount();
      return count == 0;
    }, operation: 'searchIndex.needsRebuild');
  }

  Future<int> documentCount() {
    return guard(() async {
      await ensureSchema();
      try {
        final row = await db
            .customSelect('SELECT COUNT(*) AS c FROM search_index')
            .getSingle();
        return (row.data['c'] as int?) ?? 0;
      } catch (_) {
        return 0;
      }
    }, operation: 'searchIndex.count');
  }

  /// Full rebuild from all searchable entity tables.
  Future<SearchIndexRebuildReport> rebuildAll() {
    return guard(() async {
      final sw = Stopwatch()..start();
      await ensureSchema();
      await db.customStatement(SearchIndexSchema.clearFts);

      final docs = <SearchIndexDocument>[];
      docs.addAll(await _fromJournals());
      docs.addAll(await _fromMilestones());
      docs.addAll(await _fromMedicines());
      docs.addAll(await _fromDoctorVisits());
      docs.addAll(await _fromIllnesses());
      docs.addAll(await _fromAllergies());
      docs.addAll(await _fromSchoolEvents());
      docs.addAll(await _fromAchievements());
      docs.addAll(await _fromBirthdays());
      docs.addAll(await _fromFavorites());
      docs.addAll(await _fromInterests());
      docs.addAll(await _fromFamilyEvents());
      docs.addAll(await _fromTrips());

      await _attachTags(docs);

      for (final doc in docs) {
        await upsert(doc);
      }

      sw.stop();
      await _setMeta(SearchIndexSchema.metaNeedsRebuild, '0');
      await _setMeta(
        SearchIndexSchema.metaLastRebuildAt,
        DateTime.now().toUtc().toIso8601String(),
      );
      await _setMeta(
        SearchIndexSchema.metaDocCount,
        docs.length.toString(),
      );

      AppLogger.instance.info('Search index rebuilt', {
        'documents': docs.length,
        'elapsedMs': sw.elapsedMilliseconds,
      });

      return SearchIndexRebuildReport(
        documentCount: docs.length,
        elapsedMs: sw.elapsedMilliseconds,
      );
    }, operation: 'searchIndex.rebuildAll');
  }

  /// Ensures the FTS index exists and is current.
  ///
  /// Rebuilds when [force] is true, the dirty flag is set, or the index is
  /// empty. Callers that mutate searchable rows should [markDirty].
  Future<void> ensureReady({bool force = false}) {
    return guard(() async {
      if (force || await needsRebuild()) {
        await rebuildAll();
      }
    }, operation: 'searchIndex.ensureReady');
  }

  Future<void> upsert(SearchIndexDocument doc) {
    return guard(() async {
      await ensureSchema();
      await remove(
        entityType: doc.entityType,
        entityId: doc.entityId,
      );
      await db.customStatement(
        '''
        INSERT INTO search_index(
          entity_id, entity_type, child_id, title, body, keywords, tags, event_date
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          doc.entityId,
          doc.entityType.name,
          doc.childId,
          doc.title,
          doc.body,
          doc.keywords,
          doc.tagsJoined,
          doc.eventDateMillis,
        ],
      );
    }, operation: 'searchIndex.upsert');
  }

  Future<void> remove({
    required SearchResultType entityType,
    required String entityId,
  }) {
    return guard(() async {
      await ensureSchema();
      await db.customStatement(
        '''
        DELETE FROM search_index
        WHERE entity_id = ? AND entity_type = ?
        ''',
        [entityId, entityType.name],
      );
    }, operation: 'searchIndex.remove');
  }

  Future<void> _attachTags(List<SearchIndexDocument> docs) async {
    if (docs.isEmpty) return;

    final rows = await db.customSelect(
      '''
      SELECT tl.entity_type, tl.entity_id, t.name
      FROM tag_links tl
      INNER JOIN tags t ON t.id = tl.tag_id
      WHERE tl.deleted_at IS NULL AND t.deleted_at IS NULL
      ''',
      readsFrom: {db.tagLinks, db.tags},
    ).get();

    final tagMap = <String, List<String>>{};
    for (final row in rows) {
      final key =
          '${row.data['entity_type'] as String}|${row.data['entity_id'] as String}';
      tagMap.putIfAbsent(key, () => []).add(row.data['name'] as String);
    }

    for (var i = 0; i < docs.length; i++) {
      final d = docs[i];
      final key = '${_entityTypeToken(d.entityType)}|${d.entityId}';
      final names = tagMap[key];
      if (names == null || names.isEmpty) continue;
      final merged = [...d.tags, ...names];
      final keywordExtra = names.join(' ');
      docs[i] = SearchIndexDocument(
        entityId: d.entityId,
        entityType: d.entityType,
        childId: d.childId,
        title: d.title,
        body: d.body,
        keywords: d.keywords.isEmpty
            ? keywordExtra
            : '${d.keywords} $keywordExtra',
        tags: merged,
        eventDate: d.eventDate,
      );
    }
  }

  String _entityTypeToken(SearchResultType type) {
    return switch (type) {
      SearchResultType.journal => EntityTypes.journalEntry,
      SearchResultType.milestone => EntityTypes.milestone,
      SearchResultType.medicine => EntityTypes.medicine,
      SearchResultType.doctorVisit => EntityTypes.doctorVisit,
      SearchResultType.illness => EntityTypes.illnessEpisode,
      SearchResultType.allergy => EntityTypes.allergy,
      SearchResultType.schoolEvent => EntityTypes.schoolEvent,
      SearchResultType.achievement => EntityTypes.achievement,
      SearchResultType.birthday => EntityTypes.birthday,
      SearchResultType.favorite => EntityTypes.favorite,
      SearchResultType.interest => EntityTypes.interest,
      SearchResultType.familyEvent => EntityTypes.familyEvent,
      SearchResultType.trip => EntityTypes.trip,
    };
  }

  Future<List<SearchIndexDocument>> _fromJournals() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, body, location_text, event_date
      FROM journal_entries WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.journalEntries},
    ).get();
    return rows.map((row) {
      final title = (row.data['title'] as String?)?.trim();
      final body = (row.data['body'] as String?) ?? '';
      final location = (row.data['location_text'] as String?) ?? '';
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.journal,
        childId: row.data['child_id'] as String,
        title: (title != null && title.isNotEmpty)
            ? title
            : body.split('\n').first,
        body: body,
        keywords: location,
        eventDate: _readDate(row.data['event_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromMilestones() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, description, category, event_date, created_at
      FROM milestones WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.milestones},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.milestone,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['description'] as String?) ?? '',
        keywords: (row.data['category'] as String?) ?? '',
        eventDate: _readDate(row.data['event_date'] ?? row.data['created_at']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromMedicines() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, name, reason, prescribed_by, notes, start_date, created_at
      FROM medicines WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.medicines},
    ).get();
    return rows.map((row) {
      final parts = [
        row.data['prescribed_by'],
        row.data['notes'],
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.medicine,
        childId: row.data['child_id'] as String,
        title: row.data['name'] as String,
        body: (row.data['reason'] as String?) ?? '',
        keywords: parts,
        eventDate: _readDate(row.data['start_date'] ?? row.data['created_at']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromDoctorVisits() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, doctor_name, specialty, reason, diagnosis,
             hospital_or_chamber, notes, visit_date
      FROM doctor_visits WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.doctorVisits},
    ).get();
    return rows.map((row) {
      final body = (row.data['diagnosis'] as String?) ??
          (row.data['reason'] as String?) ??
          '';
      final keywords = [
        row.data['specialty'],
        row.data['hospital_or_chamber'],
        row.data['notes'],
        row.data['reason'],
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.doctorVisit,
        childId: row.data['child_id'] as String,
        title: row.data['doctor_name'] as String,
        body: body,
        keywords: keywords,
        eventDate: _readDate(row.data['visit_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromIllnesses() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, diagnosis, notes, recovery_note, start_date
      FROM illness_episodes WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.illnessEpisodes},
    ).get();
    return rows.map((row) {
      final keywords = [
        row.data['diagnosis'],
        row.data['recovery_note'],
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.illness,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['notes'] as String?) ?? '',
        keywords: keywords,
        eventDate: _readDate(row.data['start_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromAllergies() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, allergen, allergy_type, reaction, severity, notes,
             first_observed, created_at
      FROM allergies WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.allergies},
    ).get();
    return rows.map((row) {
      final keywords = [
        row.data['allergy_type'],
        row.data['severity'],
        row.data['reaction'],
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.allergy,
        childId: row.data['child_id'] as String,
        title: row.data['allergen'] as String,
        body: (row.data['notes'] as String?) ??
            (row.data['reaction'] as String?) ??
            '',
        keywords: keywords,
        eventDate: row.data['first_observed'] != null
            ? _readDate(row.data['first_observed'])
            : _readDate(row.data['created_at']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromSchoolEvents() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, description, event_type, event_date
      FROM school_events WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.schoolEvents},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.schoolEvent,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['description'] as String?) ?? '',
        keywords: (row.data['event_type'] as String?) ?? '',
        eventDate: _readDate(row.data['event_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromAchievements() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, description, category, event_date
      FROM achievements WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.achievements},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.achievement,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['description'] as String?) ?? '',
        keywords: (row.data['category'] as String?) ?? '',
        eventDate: _readDate(row.data['event_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromBirthdays() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, age, birthday_date, theme, favorite_gift,
             location_text, parent_message, notes
      FROM birthdays WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.birthdays},
    ).get();
    return rows.map((row) {
      final age = row.data['age'] as int? ?? 0;
      final body = [
        row.data['favorite_gift'],
        row.data['parent_message'],
        row.data['notes'],
      ].whereType<String>().where((s) => s.isNotEmpty).join('\n');
      final keywords = [
        row.data['theme'],
        row.data['location_text'],
        '$age',
      ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.birthday,
        childId: row.data['child_id'] as String,
        title: 'Age $age',
        body: body,
        keywords: keywords,
        eventDate: _readDate(row.data['birthday_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromFavorites() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, category, value, notes, start_date, created_at
      FROM favorites WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.favorites},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.favorite,
        childId: row.data['child_id'] as String,
        title: row.data['value'] as String,
        body: (row.data['notes'] as String?) ?? '',
        keywords: (row.data['category'] as String?) ?? '',
        eventDate: _readDate(row.data['start_date'] ?? row.data['created_at']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromInterests() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, name, notes, first_noticed, interest_level, created_at
      FROM interests WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.interests},
    ).get();
    return rows.map((row) {
      final level = row.data['interest_level'];
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.interest,
        childId: row.data['child_id'] as String,
        title: row.data['name'] as String,
        body: (row.data['notes'] as String?) ?? '',
        keywords: level == null ? '' : 'Level $level',
        eventDate: _readDate(
          row.data['first_noticed'] ?? row.data['created_at'],
        ),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromFamilyEvents() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, event_type, event_date, location_text, story
      FROM family_events WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.familyEvents},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.familyEvent,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['story'] as String?) ?? '',
        keywords: [
          row.data['event_type'],
          row.data['location_text'],
        ].whereType<String>().where((s) => s.isNotEmpty).join(' '),
        eventDate: _readDate(row.data['event_date']),
      );
    }).toList();
  }

  Future<List<SearchIndexDocument>> _fromTrips() async {
    final rows = await db.customSelect(
      '''
      SELECT id, child_id, title, place_name, trip_type, start_date, story
      FROM trips WHERE deleted_at IS NULL
      ''',
      readsFrom: {db.trips},
    ).get();
    return rows.map((row) {
      return SearchIndexDocument(
        entityId: row.data['id'] as String,
        entityType: SearchResultType.trip,
        childId: row.data['child_id'] as String,
        title: row.data['title'] as String,
        body: (row.data['story'] as String?) ?? '',
        keywords: [
          row.data['place_name'],
          row.data['trip_type'],
        ].whereType<String>().where((s) => s.isNotEmpty).join(' '),
        eventDate: _readDate(row.data['start_date']),
      );
    }).toList();
  }

  Future<String?> _getMeta(String key) async {
    final rows = await db.customSelect(
      'SELECT value FROM search_index_meta WHERE key = ?',
      variables: [Variable.withString(key)],
    ).get();
    if (rows.isEmpty) return null;
    return rows.first.data['value'] as String?;
  }

  Future<void> _setMeta(String key, String value) async {
    await db.customStatement(
      '''
      INSERT INTO search_index_meta(key, value) VALUES (?, ?)
      ON CONFLICT(key) DO UPDATE SET value = excluded.value
      ''',
      [key, value],
    );
  }

  DateTime _readDate(Object? value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is DateTime) return value;
    if (value is int) {
      if (value > 100000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}
