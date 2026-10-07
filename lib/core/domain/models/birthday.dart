import 'package:flutter/foundation.dart';

/// Standard annual birthday interview question keys.
abstract final class BirthdayInterviewQuestions {
  static const favoriteFood = 'favorite_food';
  static const favoriteColor = 'favorite_color';
  static const favoriteCartoon = 'favorite_cartoon';
  static const favoriteBook = 'favorite_book';
  static const favoriteGame = 'favorite_game';
  static const favoriteFriend = 'favorite_friend';
  static const wantToBe = 'want_to_be';
  static const makesHappy = 'makes_happy';

  static const List<String> ordered = [
    favoriteFood,
    favoriteColor,
    favoriteCartoon,
    favoriteBook,
    favoriteGame,
    favoriteFriend,
    wantToBe,
    makesHappy,
  ];

  /// Maps interview keys that sync into the favorites table.
  static const Map<String, String> favoriteCategoryByQuestion = {
    favoriteFood: FavoriteCategories.food,
    favoriteColor: FavoriteCategories.color,
    favoriteCartoon: FavoriteCategories.cartoon,
    favoriteBook: FavoriteCategories.book,
    favoriteGame: FavoriteCategories.game,
    favoriteFriend: FavoriteCategories.friend,
  };
}

abstract final class FavoriteCategories {
  static const food = 'food';
  static const color = 'color';
  static const cartoon = 'cartoon';
  static const book = 'book';
  static const game = 'game';
  static const friend = 'friend';

  static const List<String> all = [
    food,
    color,
    cartoon,
    book,
    game,
    friend,
  ];
}

@immutable
class Birthday {
  const Birthday({
    required this.id,
    required this.childId,
    required this.age,
    required this.birthdayDate,
    required this.createdAt,
    required this.updatedAt,
    this.locationText,
    this.theme,
    this.favoriteGift,
    this.guestsText,
    this.parentMessage,
    this.notes,
    this.coverAssetId,
    this.albumId,
    this.answers = const [],
    this.deletedAt,
  });

  final String id;
  final String childId;
  final int age;
  final DateTime birthdayDate;
  final String? locationText;
  final String? theme;
  final String? favoriteGift;
  final String? guestsText;
  final String? parentMessage;
  final String? notes;
  final String? coverAssetId;
  final String? albumId;
  final List<BirthdayAnswer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Birthday copyWith({
    String? id,
    String? childId,
    int? age,
    DateTime? birthdayDate,
    String? locationText,
    bool clearLocationText = false,
    String? theme,
    bool clearTheme = false,
    String? favoriteGift,
    bool clearFavoriteGift = false,
    String? guestsText,
    bool clearGuestsText = false,
    String? parentMessage,
    bool clearParentMessage = false,
    String? notes,
    bool clearNotes = false,
    String? coverAssetId,
    bool clearCoverAssetId = false,
    String? albumId,
    bool clearAlbumId = false,
    List<BirthdayAnswer>? answers,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Birthday(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      age: age ?? this.age,
      birthdayDate: birthdayDate ?? this.birthdayDate,
      locationText: clearLocationText
          ? null
          : (locationText ?? this.locationText),
      theme: clearTheme ? null : (theme ?? this.theme),
      favoriteGift: clearFavoriteGift
          ? null
          : (favoriteGift ?? this.favoriteGift),
      guestsText: clearGuestsText ? null : (guestsText ?? this.guestsText),
      parentMessage: clearParentMessage
          ? null
          : (parentMessage ?? this.parentMessage),
      notes: clearNotes ? null : (notes ?? this.notes),
      coverAssetId: clearCoverAssetId
          ? null
          : (coverAssetId ?? this.coverAssetId),
      albumId: clearAlbumId ? null : (albumId ?? this.albumId),
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

@immutable
class BirthdayAnswer {
  const BirthdayAnswer({
    required this.id,
    required this.birthdayId,
    required this.questionKey,
    required this.answer,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String birthdayId;
  final String questionKey;
  final String answer;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  BirthdayAnswer copyWith({
    String? id,
    String? birthdayId,
    String? questionKey,
    String? answer,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return BirthdayAnswer(
      id: id ?? this.id,
      birthdayId: birthdayId ?? this.birthdayId,
      questionKey: questionKey ?? this.questionKey,
      answer: answer ?? this.answer,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

@immutable
class Favorite {
  const Favorite({
    required this.id,
    required this.childId,
    required this.category,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.endDate,
    this.notes,
    this.sourceBirthdayId,
    this.recordedAge,
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String category;
  final String value;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;
  final String? sourceBirthdayId;
  final int? recordedAge;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isCurrent => endDate == null;

  Favorite copyWith({
    String? id,
    String? childId,
    String? category,
    String? value,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? notes,
    bool clearNotes = false,
    String? sourceBirthdayId,
    bool clearSourceBirthdayId = false,
    int? recordedAge,
    bool clearRecordedAge = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Favorite(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      category: category ?? this.category,
      value: value ?? this.value,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      notes: clearNotes ? null : (notes ?? this.notes),
      sourceBirthdayId: clearSourceBirthdayId
          ? null
          : (sourceBirthdayId ?? this.sourceBirthdayId),
      recordedAge: clearRecordedAge
          ? null
          : (recordedAge ?? this.recordedAge),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

/// One question row compared across ages.
@immutable
class BirthdayAnswerComparison {
  const BirthdayAnswerComparison({
    required this.questionKey,
    required this.byAge,
  });

  final String questionKey;
  /// age -> answer text
  final Map<int, String> byAge;
}
