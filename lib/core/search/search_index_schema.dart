/// Raw SQL for the FTS5 search index (not a Drift table).
abstract final class SearchIndexSchema {
  static const tableName = 'search_index';
  static const metaTableName = 'search_index_meta';

  /// FTS5 virtual table — columns match technical design §33.
  ///
  /// Column indices for highlight/snippet:
  /// 0 entity_id, 1 entity_type, 2 child_id, 3 title, 4 body,
  /// 5 keywords, 6 tags, 7 event_date.
  static const createFts = '''
CREATE VIRTUAL TABLE IF NOT EXISTS search_index USING fts5(
  entity_id UNINDEXED,
  entity_type UNINDEXED,
  child_id UNINDEXED,
  title,
  body,
  keywords,
  tags UNINDEXED,
  event_date UNINDEXED,
  tokenize = 'unicode61 remove_diacritics 2'
)
''';

  static const createMeta = '''
CREATE TABLE IF NOT EXISTS search_index_meta (
  key TEXT NOT NULL PRIMARY KEY,
  value TEXT NOT NULL
)
''';

  static const dropFts = 'DROP TABLE IF EXISTS search_index';
  static const clearFts = "DELETE FROM search_index";

  static const metaNeedsRebuild = 'needs_rebuild';
  static const metaLastRebuildAt = 'last_rebuild_at';
  static const metaDocCount = 'doc_count';
}
