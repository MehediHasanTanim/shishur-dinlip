import 'package:flutter/material.dart';

/// Markers written by SQLite FTS5 `highlight` / `snippet`.
abstract final class SearchHighlightMarkers {
  static const start = '\uE000';
  static const end = '\uE001';
}

/// Turns FTS highlight markers into styled [InlineSpan]s.
List<InlineSpan> searchHighlightSpans(
  String? text, {
  required TextStyle base,
  TextStyle? highlight,
}) {
  if (text == null || text.isEmpty) return const [];
  final hl = highlight ??
      base.copyWith(
        fontWeight: FontWeight.w700,
        backgroundColor: const Color(0x336D5B00),
      );

  final spans = <InlineSpan>[];
  var i = 0;
  while (i < text.length) {
    final start = text.indexOf(SearchHighlightMarkers.start, i);
    if (start < 0) {
      spans.add(TextSpan(text: text.substring(i), style: base));
      break;
    }
    if (start > i) {
      spans.add(TextSpan(text: text.substring(i, start), style: base));
    }
    final end = text.indexOf(SearchHighlightMarkers.end, start + 1);
    if (end < 0) {
      spans.add(TextSpan(text: text.substring(start + 1), style: hl));
      break;
    }
    spans.add(
      TextSpan(
        text: text.substring(start + SearchHighlightMarkers.start.length, end),
        style: hl,
      ),
    );
    i = end + SearchHighlightMarkers.end.length;
  }
  return spans;
}

String stripSearchHighlights(String? text) {
  if (text == null) return '';
  return text
      .replaceAll(SearchHighlightMarkers.start, '')
      .replaceAll(SearchHighlightMarkers.end, '');
}
