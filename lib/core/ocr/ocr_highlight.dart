import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/app/theme/app_colors.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';

/// Builds highlighted spans for OCR full text using extracted field ranges.
List<InlineSpan> ocrHighlightSpans(
  String fullText,
  List<OcrExtractedField> fields, {
  TextStyle? base,
  TextStyle? highlight,
}) {
  if (fullText.isEmpty) return const [];
  final ranges = fields
      .where((f) => f.sourceStart != null && f.sourceEnd != null)
      .map((f) => (f.sourceStart!, f.sourceEnd!))
      .where((r) => r.$1 >= 0 && r.$2 > r.$1 && r.$1 < fullText.length)
      .toList()
    ..sort((a, b) => a.$1.compareTo(b.$1));

  final baseStyle = base ?? const TextStyle(height: 1.4);
  final hlStyle = highlight ??
      baseStyle.copyWith(
        backgroundColor: AppColors.tertiary.withValues(alpha: 0.35),
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  if (ranges.isEmpty) {
    return [TextSpan(text: fullText, style: baseStyle)];
  }

  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final range in ranges) {
    final start = range.$1.clamp(0, fullText.length);
    final end = range.$2.clamp(0, fullText.length);
    if (start < cursor) continue;
    if (start > cursor) {
      spans.add(TextSpan(text: fullText.substring(cursor, start), style: baseStyle));
    }
    spans.add(TextSpan(text: fullText.substring(start, end), style: hlStyle));
    cursor = end;
  }
  if (cursor < fullText.length) {
    spans.add(TextSpan(text: fullText.substring(cursor), style: baseStyle));
  }
  return spans;
}
