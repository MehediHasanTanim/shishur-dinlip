import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/models/first_word.dart';

abstract final class FirstWordMapper {
  static FirstWord toDomain(FirstWordRow row) {
    return FirstWord(
      id: row.id,
      childId: row.childId,
      word: row.word,
      languageCode: row.languageCode,
      eventDate: row.eventDate,
      datePrecision: DatePrecision.fromStorage(row.datePrecision),
      contextNote: row.contextNote,
      audioAssetId: row.audioAssetId,
      audioPlaceholder: row.audioPlaceholder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static FirstWordsCompanion toCompanion(FirstWord word) {
    return FirstWordsCompanion(
      id: Value(word.id),
      childId: Value(word.childId),
      word: Value(word.word),
      languageCode: Value(word.languageCode),
      eventDate: Value(word.eventDate),
      datePrecision: Value(word.datePrecision.name),
      contextNote: Value(word.contextNote),
      audioAssetId: Value(word.audioAssetId),
      audioPlaceholder: Value(word.audioPlaceholder),
      createdAt: Value(word.createdAt),
      updatedAt: Value(word.updatedAt),
      deletedAt: Value(word.deletedAt),
    );
  }
}
