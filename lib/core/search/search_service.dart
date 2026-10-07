import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

/// Local SQL `LIKE` search across core memory/health/school tables.
class SearchService extends RepositoryBase {
  SearchService(super.db);

  Future<List<SearchResult>> search(SearchQuery query) {
    return guard(() async {
      final q = query.text.trim();
      if (q.isEmpty) return const [];
      final pattern = '%$q%';
      final results = <SearchResult>[];

      void addIfAllowed(SearchResultType type, SearchResult item) {
        if (query.type != null && query.type != type) return;
        if (!_inRange(item.eventDate, query.fromDate, query.toDate)) return;
        results.add(item);
      }

      if (query.type == null || query.type == SearchResultType.journal) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, title, body, event_date FROM journal_entries
          WHERE child_id = ? AND deleted_at IS NULL
            AND (IFNULL(title, '') LIKE ? OR body LIKE ?
                 OR IFNULL(location_text, '') LIKE ?)
          ORDER BY event_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.journalEntries},
        ).get();
        for (final row in rows) {
          final title = (row.data['title'] as String?)?.trim();
          final body = (row.data['body'] as String?) ?? '';
          addIfAllowed(
            SearchResultType.journal,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.journal,
              title: (title != null && title.isNotEmpty)
                  ? title
                  : body.split('\n').first,
              snippet: body.length > 120 ? '${body.substring(0, 120)}…' : body,
              eventDate: _readDate(row.data['event_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.milestone) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, title, description, event_date, created_at, category
          FROM milestones
          WHERE child_id = ? AND deleted_at IS NULL
            AND (title LIKE ? OR IFNULL(description, '') LIKE ?
                 OR category LIKE ?)
          ORDER BY COALESCE(event_date, created_at) DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.milestones},
        ).get();
        for (final row in rows) {
          final event = row.data['event_date'] ?? row.data['created_at'];
          addIfAllowed(
            SearchResultType.milestone,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.milestone,
              title: row.data['title'] as String,
              subtitle: row.data['category'] as String?,
              snippet: row.data['description'] as String?,
              eventDate: _readDate(event),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.medicine) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, name, reason, prescribed_by, start_date, created_at
          FROM medicines
          WHERE child_id = ? AND deleted_at IS NULL
            AND (name LIKE ? OR IFNULL(reason, '') LIKE ?
                 OR IFNULL(prescribed_by, '') LIKE ?
                 OR IFNULL(notes, '') LIKE ?)
          ORDER BY COALESCE(start_date, created_at) DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.medicines},
        ).get();
        for (final row in rows) {
          final event = row.data['start_date'] ?? row.data['created_at'];
          addIfAllowed(
            SearchResultType.medicine,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.medicine,
              title: row.data['name'] as String,
              subtitle: row.data['prescribed_by'] as String?,
              snippet: row.data['reason'] as String?,
              eventDate: _readDate(event),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.doctorVisit) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, doctor_name, specialty, reason, diagnosis, visit_date
          FROM doctor_visits
          WHERE child_id = ? AND deleted_at IS NULL
            AND (doctor_name LIKE ? OR IFNULL(specialty, '') LIKE ?
                 OR IFNULL(reason, '') LIKE ? OR IFNULL(diagnosis, '') LIKE ?
                 OR IFNULL(hospital_or_chamber, '') LIKE ?
                 OR IFNULL(notes, '') LIKE ?)
          ORDER BY visit_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.doctorVisits},
        ).get();
        for (final row in rows) {
          addIfAllowed(
            SearchResultType.doctorVisit,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.doctorVisit,
              title: row.data['doctor_name'] as String,
              subtitle: row.data['specialty'] as String?,
              snippet: (row.data['diagnosis'] as String?) ??
                  (row.data['reason'] as String?),
              eventDate: _readDate(row.data['visit_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.illness) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, title, diagnosis, notes, start_date
          FROM illness_episodes
          WHERE child_id = ? AND deleted_at IS NULL
            AND (title LIKE ? OR IFNULL(diagnosis, '') LIKE ?
                 OR IFNULL(notes, '') LIKE ?
                 OR IFNULL(recovery_note, '') LIKE ?)
          ORDER BY start_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.illnessEpisodes},
        ).get();
        for (final row in rows) {
          addIfAllowed(
            SearchResultType.illness,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.illness,
              title: row.data['title'] as String,
              subtitle: row.data['diagnosis'] as String?,
              snippet: row.data['notes'] as String?,
              eventDate: _readDate(row.data['start_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.schoolEvent) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, title, description, event_type, event_date
          FROM school_events
          WHERE child_id = ? AND deleted_at IS NULL
            AND (title LIKE ? OR IFNULL(description, '') LIKE ?
                 OR event_type LIKE ?)
          ORDER BY event_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.schoolEvents},
        ).get();
        for (final row in rows) {
          addIfAllowed(
            SearchResultType.schoolEvent,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.schoolEvent,
              title: row.data['title'] as String,
              subtitle: row.data['event_type'] as String?,
              snippet: row.data['description'] as String?,
              eventDate: _readDate(row.data['event_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.achievement) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, title, description, category, event_date
          FROM achievements
          WHERE child_id = ? AND deleted_at IS NULL
            AND (title LIKE ? OR IFNULL(description, '') LIKE ?
                 OR category LIKE ?)
          ORDER BY event_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.achievements},
        ).get();
        for (final row in rows) {
          addIfAllowed(
            SearchResultType.achievement,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.achievement,
              title: row.data['title'] as String,
              subtitle: row.data['category'] as String?,
              snippet: row.data['description'] as String?,
              eventDate: _readDate(row.data['event_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.birthday) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, age, birthday_date, theme, favorite_gift,
                 location_text, parent_message, notes
          FROM birthdays
          WHERE child_id = ? AND deleted_at IS NULL
            AND (IFNULL(theme, '') LIKE ? OR IFNULL(favorite_gift, '') LIKE ?
                 OR IFNULL(location_text, '') LIKE ?
                 OR IFNULL(parent_message, '') LIKE ?
                 OR IFNULL(notes, '') LIKE ?
                 OR CAST(age AS TEXT) LIKE ?)
          ORDER BY birthday_date DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.birthdays},
        ).get();
        for (final row in rows) {
          final age = row.data['age'] as int? ?? 0;
          addIfAllowed(
            SearchResultType.birthday,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.birthday,
              title: 'Age $age',
              subtitle: row.data['theme'] as String?,
              snippet: row.data['favorite_gift'] as String? ??
                  row.data['parent_message'] as String?,
              eventDate: _readDate(row.data['birthday_date']),
            ),
          );
        }
      }

      if (query.type == null || query.type == SearchResultType.favorite) {
        final rows = await db.customSelect(
          '''
          SELECT id, child_id, category, value, notes, start_date, recorded_age
          FROM favorites
          WHERE child_id = ? AND deleted_at IS NULL
            AND (value LIKE ? OR category LIKE ? OR IFNULL(notes, '') LIKE ?)
          ORDER BY IFNULL(start_date, created_at) DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withString(query.childId),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withString(pattern),
            Variable.withInt(query.limit),
          ],
          readsFrom: {db.favorites},
        ).get();
        for (final row in rows) {
          addIfAllowed(
            SearchResultType.favorite,
            SearchResult(
              id: row.data['id'] as String,
              childId: row.data['child_id'] as String,
              type: SearchResultType.favorite,
              title: row.data['value'] as String,
              subtitle: row.data['category'] as String?,
              snippet: row.data['notes'] as String?,
              eventDate: _readDate(row.data['start_date']),
            ),
          );
        }
      }

      results.sort((a, b) => b.eventDate.compareTo(a.eventDate));
      if (results.length > query.limit) {
        return results.take(query.limit).toList();
      }
      return results;
    }, operation: 'search.query');
  }

  bool _inRange(DateTime date, DateTime? from, DateTime? to) {
    final d = DateTime(date.year, date.month, date.day);
    if (from != null) {
      final f = DateTime(from.year, from.month, from.day);
      if (d.isBefore(f)) return false;
    }
    if (to != null) {
      final t = DateTime(to.year, to.month, to.day);
      if (d.isAfter(t)) return false;
    }
    return true;
  }

  DateTime _readDate(Object? value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is DateTime) return value;
    if (value is int) {
      // Drift may store micros or millis.
      if (value > 100000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.parse(value.toString());
  }
}
