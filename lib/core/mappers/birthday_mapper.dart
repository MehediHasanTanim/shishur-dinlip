import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';

abstract final class BirthdayMapper {
  static Birthday toDomain(
    BirthdayRow row, {
    List<BirthdayAnswer> answers = const [],
  }) {
    return Birthday(
      id: row.id,
      childId: row.childId,
      age: row.age,
      birthdayDate: row.birthdayDate,
      locationText: row.locationText,
      theme: row.theme,
      favoriteGift: row.favoriteGift,
      guestsText: row.guestsText,
      parentMessage: row.parentMessage,
      notes: row.notes,
      coverAssetId: row.coverAssetId,
      albumId: row.albumId,
      answers: answers,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static BirthdaysCompanion toCompanion(Birthday birthday) {
    return BirthdaysCompanion(
      id: Value(birthday.id),
      childId: Value(birthday.childId),
      age: Value(birthday.age),
      birthdayDate: Value(birthday.birthdayDate),
      locationText: Value(birthday.locationText),
      theme: Value(birthday.theme),
      favoriteGift: Value(birthday.favoriteGift),
      guestsText: Value(birthday.guestsText),
      parentMessage: Value(birthday.parentMessage),
      notes: Value(birthday.notes),
      coverAssetId: Value(birthday.coverAssetId),
      albumId: Value(birthday.albumId),
      createdAt: Value(birthday.createdAt),
      updatedAt: Value(birthday.updatedAt),
      deletedAt: Value(birthday.deletedAt),
    );
  }

  static BirthdayAnswer answerToDomain(BirthdayAnswerRow row) {
    return BirthdayAnswer(
      id: row.id,
      birthdayId: row.birthdayId,
      questionKey: row.questionKey,
      answer: row.answer,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static BirthdayAnswersCompanion answerToCompanion(BirthdayAnswer answer) {
    return BirthdayAnswersCompanion(
      id: Value(answer.id),
      birthdayId: Value(answer.birthdayId),
      questionKey: Value(answer.questionKey),
      answer: Value(answer.answer),
      sortOrder: Value(answer.sortOrder),
      createdAt: Value(answer.createdAt),
      updatedAt: Value(answer.updatedAt),
      deletedAt: Value(answer.deletedAt),
    );
  }
}
