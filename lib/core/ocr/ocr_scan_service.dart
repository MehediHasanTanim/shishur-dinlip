import 'dart:io';

import 'package:shishur_dinlipi/core/ocr/ocr_engine.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_field_extractor.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';

/// Runs local OCR and field extraction. Never persists medical facts.
class OcrScanService {
  OcrScanService({
    required this.engine,
    this.extractor = const OcrFieldExtractor(),
  });

  final OcrEngine engine;
  final OcrFieldExtractor extractor;

  /// Photo → OCR → suggested fields. [OcrReviewDraft.confirmed] is always false.
  Future<OcrReviewDraft> scan({
    required OcrScanType scanType,
    required File imageFile,
  }) async {
    final raw = await engine.recognize(imageFile);
    final fields = extractor.extract(scanType, raw);
    return OcrReviewDraft(
      scanType: scanType,
      imagePath: imageFile.path,
      raw: raw,
      fields: fields,
      confirmed: false,
    );
  }
}
