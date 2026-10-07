import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';

@immutable
class FirstWord {
  const FirstWord({
    required this.id,
    required this.childId,
    required this.word,
    required this.datePrecision,
    required this.createdAt,
    required this.updatedAt,
    this.languageCode,
    this.eventDate,
    this.contextNote,
    this.audioAssetId,
    this.audioPlaceholder = false,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String word;
  final String? languageCode;
  final DateTime? eventDate;
  final DatePrecision datePrecision;
  final String? contextNote;
  final String? audioAssetId;
  final bool audioPlaceholder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  FirstWord copyWith({
    String? id,
    String? childId,
    String? word,
    String? languageCode,
    bool clearLanguageCode = false,
    DateTime? eventDate,
    bool clearEventDate = false,
    DatePrecision? datePrecision,
    String? contextNote,
    bool clearContextNote = false,
    String? audioAssetId,
    bool clearAudioAssetId = false,
    bool? audioPlaceholder,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return FirstWord(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      word: word ?? this.word,
      languageCode: clearLanguageCode
          ? null
          : (languageCode ?? this.languageCode),
      eventDate: clearEventDate ? null : (eventDate ?? this.eventDate),
      datePrecision: datePrecision ?? this.datePrecision,
      contextNote: clearContextNote ? null : (contextNote ?? this.contextNote),
      audioAssetId: clearAudioAssetId
          ? null
          : (audioAssetId ?? this.audioAssetId),
      audioPlaceholder: audioPlaceholder ?? this.audioPlaceholder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
