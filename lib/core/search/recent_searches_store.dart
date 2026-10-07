import 'dart:convert';

import 'package:shishur_dinlipi/core/database/app_database.dart';

/// Persists recent search queries in settings (per device).
class RecentSearchesStore {
  RecentSearchesStore(this._db);

  final AppDatabase _db;
  static const _key = 'search.recent_queries';
  static const _max = 8;

  Future<List<String>> list() async {
    final raw = await _db.settingsDao.getValue(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
    } catch (_) {}
    return const [];
  }

  Future<void> add(String query) async {
    final cleaned = query.trim();
    if (cleaned.isEmpty) return;
    final current = await list();
    final next = [
      cleaned,
      ...current.where((q) => q.toLowerCase() != cleaned.toLowerCase()),
    ].take(_max).toList();
    await _db.settingsDao.setValue(
      _key,
      jsonEncode(next),
      DateTime.now().toUtc(),
    );
  }

  Future<void> clear() async {
    await _db.settingsDao.setValue(_key, '[]', DateTime.now().toUtc());
  }
}
