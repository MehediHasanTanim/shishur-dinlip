import 'package:flutter/foundation.dart';

/// Document kinds supported by the OCR scan flow.
enum OcrScanType {
  vaccinationCard,
  prescription,
  diagnosticReport,
}

/// Keys for extracted medical fields (editable before save).
abstract final class OcrFieldKeys {
  static const vaccineName = 'vaccineName';
  static const doseLabel = 'doseLabel';
  static const givenDate = 'givenDate';
  static const batchNumber = 'batchNumber';
  static const clinicName = 'clinicName';
  static const providerName = 'providerName';

  static const medicineName = 'medicineName';
  static const dosage = 'dosage';
  static const strength = 'strength';
  static const frequency = 'frequency';
  static const prescribedBy = 'prescribedBy';
  static const startDate = 'startDate';

  static const documentTitle = 'documentTitle';
  static const documentDate = 'documentDate';
  static const facility = 'facility';
  static const findings = 'findings';

  static const notes = 'notes';
}

@immutable
class OcrTextBlock {
  const OcrTextBlock({
    required this.text,
    this.start = 0,
    this.end = 0,
  });

  final String text;
  final int start;
  final int end;
}

@immutable
class OcrRawResult {
  const OcrRawResult({
    required this.fullText,
    this.blocks = const [],
    this.engineName = 'local',
  });

  final String fullText;
  final List<OcrTextBlock> blocks;
  final String engineName;
}

@immutable
class OcrExtractedField {
  const OcrExtractedField({
    required this.key,
    required this.labelKey,
    required this.value,
    this.matchedText,
    this.confidence = 0.5,
    this.sourceStart,
    this.sourceEnd,
  });

  final String key;

  /// Stable id used for l10n (e.g. `ocrFieldVaccineName`).
  final String labelKey;
  final String value;
  final String? matchedText;
  final double confidence;
  final int? sourceStart;
  final int? sourceEnd;

  OcrExtractedField copyWith({String? value}) {
    return OcrExtractedField(
      key: key,
      labelKey: labelKey,
      value: value ?? this.value,
      matchedText: matchedText,
      confidence: confidence,
      sourceStart: sourceStart,
      sourceEnd: sourceEnd,
    );
  }
}

/// Intermediate draft — never persisted until parent confirms.
@immutable
class OcrReviewDraft {
  const OcrReviewDraft({
    required this.scanType,
    required this.imagePath,
    required this.raw,
    required this.fields,
    this.confirmed = false,
  });

  final OcrScanType scanType;
  final String imagePath;
  final OcrRawResult raw;
  final List<OcrExtractedField> fields;

  /// Must stay false until the parent taps confirm.
  final bool confirmed;

  String? valueOf(String key) {
    for (final f in fields) {
      if (f.key == key) {
        final v = f.value.trim();
        return v.isEmpty ? null : v;
      }
    }
    return null;
  }

  OcrReviewDraft withFieldValue(String key, String value) {
    return OcrReviewDraft(
      scanType: scanType,
      imagePath: imagePath,
      raw: raw,
      confirmed: false,
      fields: [
        for (final f in fields)
          if (f.key == key) f.copyWith(value: value) else f,
      ],
    );
  }

  OcrReviewDraft markConfirmed() => OcrReviewDraft(
        scanType: scanType,
        imagePath: imagePath,
        raw: raw,
        fields: fields,
        confirmed: true,
      );
}

@immutable
class OcrConfirmResult {
  const OcrConfirmResult({
    required this.scanType,
    required this.entityId,
    this.documentId,
  });

  final OcrScanType scanType;
  final String entityId;
  final String? documentId;
}
