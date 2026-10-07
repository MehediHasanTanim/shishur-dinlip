import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

String birthdayQuestionLabel(AppLocalizations l10n, String key) {
  return switch (key) {
    BirthdayInterviewQuestions.favoriteFood => l10n.birthdayQFavoriteFood,
    BirthdayInterviewQuestions.favoriteColor => l10n.birthdayQFavoriteColor,
    BirthdayInterviewQuestions.favoriteCartoon => l10n.birthdayQFavoriteCartoon,
    BirthdayInterviewQuestions.favoriteBook => l10n.birthdayQFavoriteBook,
    BirthdayInterviewQuestions.favoriteGame => l10n.birthdayQFavoriteGame,
    BirthdayInterviewQuestions.favoriteFriend => l10n.birthdayQFavoriteFriend,
    BirthdayInterviewQuestions.wantToBe => l10n.birthdayQWantToBe,
    BirthdayInterviewQuestions.makesHappy => l10n.birthdayQMakesHappy,
    _ => key,
  };
}

String favoriteCategoryLabel(AppLocalizations l10n, String category) {
  return switch (category) {
    FavoriteCategories.food => l10n.favoriteCatFood,
    FavoriteCategories.color => l10n.favoriteCatColor,
    FavoriteCategories.cartoon => l10n.favoriteCatCartoon,
    FavoriteCategories.book => l10n.favoriteCatBook,
    FavoriteCategories.game => l10n.favoriteCatGame,
    FavoriteCategories.friend => l10n.favoriteCatFriend,
    _ => category,
  };
}

Map<String, String> birthdayQuestionLabelMap(AppLocalizations l10n) {
  return {
    for (final key in BirthdayInterviewQuestions.ordered)
      key: birthdayQuestionLabel(l10n, key),
  };
}
