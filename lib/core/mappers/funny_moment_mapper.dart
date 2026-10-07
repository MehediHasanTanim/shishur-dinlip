import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';

abstract final class FunnyMomentMapper {
  static FunnyMoment toDomain(FunnyMomentRow row) {
    return FunnyMoment(
      id: row.id,
      childId: row.childId,
      eventDate: row.eventDate,
      title: row.title,
      story: row.story,
      quoteText: row.quoteText,
      peoplePresent: row.peoplePresent,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static FunnyMomentsCompanion toCompanion(FunnyMoment moment) {
    return FunnyMomentsCompanion(
      id: Value(moment.id),
      childId: Value(moment.childId),
      eventDate: Value(moment.eventDate),
      title: Value(moment.title),
      story: Value(moment.story),
      quoteText: Value(moment.quoteText),
      peoplePresent: Value(moment.peoplePresent),
      isFavorite: Value(moment.isFavorite),
      createdAt: Value(moment.createdAt),
      updatedAt: Value(moment.updatedAt),
      deletedAt: Value(moment.deletedAt),
    );
  }
}
