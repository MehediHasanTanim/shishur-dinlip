import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';

abstract final class JournalEntryMapper {
  static JournalEntry toDomain(
    JournalEntryRow row, {
    List<String> tagNames = const [],
  }) {
    return JournalEntry(
      id: row.id,
      childId: row.childId,
      entryType: row.entryType,
      title: row.title,
      body: row.body,
      eventDate: row.eventDate,
      mood: row.mood,
      locationText: row.locationText,
      isPrivate: row.isPrivate,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      tagNames: tagNames,
    );
  }

  static JournalEntriesCompanion toCompanion(JournalEntry entry) {
    return JournalEntriesCompanion(
      id: Value(entry.id),
      childId: Value(entry.childId),
      entryType: Value(entry.entryType),
      title: Value(entry.title),
      body: Value(entry.body),
      eventDate: Value(entry.eventDate),
      mood: Value(entry.mood),
      locationText: Value(entry.locationText),
      isPrivate: Value(entry.isPrivate),
      isFavorite: Value(entry.isFavorite),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
      deletedAt: Value(entry.deletedAt),
    );
  }
}
