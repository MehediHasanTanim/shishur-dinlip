import 'package:flutter/foundation.dart';

enum SearchResultType {
  journal,
  milestone,
  medicine,
  doctorVisit,
  illness,
  schoolEvent,
  achievement,
  birthday,
  favorite,
  interest,
  familyEvent,
  trip,
}

@immutable
class SearchResult {
  const SearchResult({
    required this.id,
    required this.childId,
    required this.type,
    required this.title,
    required this.eventDate,
    this.subtitle,
    this.snippet,
  });

  final String id;
  final String childId;
  final SearchResultType type;
  final String title;
  final String? subtitle;
  final String? snippet;
  final DateTime eventDate;
}

@immutable
class SearchQuery {
  const SearchQuery({
    required this.text,
    required this.childId,
    this.type,
    this.fromDate,
    this.toDate,
    this.limit = 100,
  });

  final String text;
  final String childId;
  final SearchResultType? type;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int limit;
}
