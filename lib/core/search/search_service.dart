import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';
import 'package:shishur_dinlipi/core/search/search_highlight.dart';
import 'package:shishur_dinlipi/core/search/search_index_rebuild_service.dart';

/// FTS5-backed search across indexed memory/health/school records.
class SearchService extends RepositoryBase {
  SearchService(
    super.db, {
    SearchIndexRebuildService? index,
  }) : _index = index ?? SearchIndexRebuildService(db);

  final SearchIndexRebuildService _index;

  SearchIndexRebuildService get index => _index;

  Future<List<SearchResult>> search(SearchQuery query) {
    return guard(() async {
      final q = query.text.trim();
      final tag = query.tag?.trim();
      if (q.isEmpty && (tag == null || tag.isEmpty)) return const [];

      // Rebuild when dirty/empty so results stay current after writes.
      await _index.ensureReady(force: true);

      final match = q.isEmpty ? null : _buildFtsMatch(q);
      final fromMs = query.fromDate == null
          ? null
          : DateTime(
              query.fromDate!.year,
              query.fromDate!.month,
              query.fromDate!.day,
            ).millisecondsSinceEpoch;
      final toMs = query.toDate == null
          ? null
          : DateTime(
              query.toDate!.year,
              query.toDate!.month,
              query.toDate!.day,
              23,
              59,
              59,
              999,
            ).millisecondsSinceEpoch;
      final tagNeedle = tag == null || tag.isEmpty
          ? null
          : ' ${tag.toLowerCase()} ';
      final typeName = query.type?.name;

      final hlStart = SearchHighlightMarkers.start;
      final hlEnd = SearchHighlightMarkers.end;

      final sql = StringBuffer('''
        SELECT
          entity_id,
          entity_type,
          child_id,
          title,
          body,
          tags,
          event_date,
          highlight(search_index, 3, ?, ?) AS title_hl,
          snippet(search_index, 4, ?, ?, '…', 28) AS body_snip
        FROM search_index
        WHERE child_id = ?
      ''');

      final variables = <Variable<Object>>[
        Variable.withString(hlStart),
        Variable.withString(hlEnd),
        Variable.withString(hlStart),
        Variable.withString(hlEnd),
        Variable.withString(query.childId),
      ];

      if (match != null) {
        sql.write(' AND search_index MATCH ?');
        variables.add(Variable.withString(match));
      }

      if (typeName != null) {
        sql.write(' AND entity_type = ?');
        variables.add(Variable.withString(typeName));
      }

      if (fromMs != null) {
        sql.write(' AND CAST(event_date AS INTEGER) >= ?');
        variables.add(Variable.withInt(fromMs));
      }
      if (toMs != null) {
        sql.write(' AND CAST(event_date AS INTEGER) <= ?');
        variables.add(Variable.withInt(toMs));
      }
      if (tagNeedle != null) {
        sql.write(" AND (' ' || lower(tags) || ' ') LIKE ?");
        variables.add(Variable.withString('%$tagNeedle%'));
      }

      sql.write(
        match != null
            ? ' ORDER BY bm25(search_index), CAST(event_date AS INTEGER) DESC'
            : ' ORDER BY CAST(event_date AS INTEGER) DESC',
      );
      sql.write(' LIMIT ?');
      variables.add(Variable.withInt(query.limit));

      final rows = await db
          .customSelect(sql.toString(), variables: variables)
          .get();

      final results = <SearchResult>[];
      for (final row in rows) {
        final type = _parseType(row.data['entity_type'] as String?);
        if (type == null) continue;
        final title = (row.data['title'] as String?) ?? '';
        final body = (row.data['body'] as String?) ?? '';
        final titleHl = row.data['title_hl'] as String?;
        final bodySnip = row.data['body_snip'] as String?;
        final tagsRaw = (row.data['tags'] as String?) ?? '';
        final tags = tagsRaw
            .split(RegExp(r'\s+'))
            .where((t) => t.isNotEmpty)
            .toList();

        final cleanTitle = stripSearchHighlights(titleHl);
        final cleanSnippet = stripSearchHighlights(bodySnip);
        results.add(
          SearchResult(
            id: row.data['entity_id'] as String,
            childId: row.data['child_id'] as String,
            type: type,
            title: cleanTitle.isNotEmpty ? cleanTitle : title,
            subtitle: tags.isEmpty ? null : tags.join(', '),
            snippet: cleanSnippet.isNotEmpty
                ? cleanSnippet
                : (body.length > 120 ? '${body.substring(0, 120)}…' : body),
            highlightedTitle: titleHl,
            highlightedSnippet: bodySnip,
            tags: tags,
            eventDate: _readDateMillis(row.data['event_date']),
          ),
        );
      }
      return results;
    }, operation: 'search.query');
  }

  /// Escapes FTS5 special characters and builds a prefix AND query.
  String? _buildFtsMatch(String raw) {
    final tokens = raw
        .split(RegExp(r'\s+'))
        .map(_sanitizeToken)
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return null;
    // Prefix match approximates previous LIKE '%q%' for Latin tokens.
    return tokens.map((t) => '$t*').join(' AND ');
  }

  String _sanitizeToken(String token) {
    return token
        .replaceAll('"', ' ')
        .replaceAll("'", ' ')
        .replaceAll('*', ' ')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll(':', ' ')
        .replaceAll('^', ' ')
        .replaceAll('-', ' ')
        .trim();
  }

  SearchResultType? _parseType(String? name) {
    if (name == null) return null;
    for (final t in SearchResultType.values) {
      if (t.name == name) return t;
    }
    return null;
  }

  DateTime _readDateMillis(Object? value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (value is DateTime) return value;
    if (value is int) {
      if (value > 100000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    final parsed = int.tryParse(value.toString());
    if (parsed != null) {
      return DateTime.fromMillisecondsSinceEpoch(parsed);
    }
    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
}
