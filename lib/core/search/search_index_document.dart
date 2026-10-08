import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/search_result.dart';

@immutable
class SearchIndexDocument {
  const SearchIndexDocument({
    required this.entityId,
    required this.entityType,
    required this.childId,
    required this.title,
    required this.eventDate,
    this.body = '',
    this.keywords = '',
    this.tags = const [],
  });

  final String entityId;
  final SearchResultType entityType;
  final String childId;
  final String title;
  final String body;
  final String keywords;
  final List<String> tags;
  final DateTime eventDate;

  String get tagsJoined =>
      tags.map((t) => t.trim().toLowerCase()).where((t) => t.isNotEmpty).join(' ');

  int get eventDateMillis => eventDate.millisecondsSinceEpoch;
}
