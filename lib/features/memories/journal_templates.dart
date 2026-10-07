import 'package:shishur_dinlipi/core/domain/entity_types.dart';

enum JournalTemplate {
  somethingFunny,
  somethingNew,
  proudMoment,
  difficultDay,
  favoriteMoment,
  photoMemory,
}

extension JournalTemplateX on JournalTemplate {
  String get entryType => switch (this) {
    JournalTemplate.somethingFunny => JournalEntryTypes.memory,
    JournalTemplate.somethingNew => JournalEntryTypes.memory,
    JournalTemplate.proudMoment => JournalEntryTypes.proudMoment,
    JournalTemplate.difficultDay => JournalEntryTypes.difficultDay,
    JournalTemplate.favoriteMoment => JournalEntryTypes.memory,
    JournalTemplate.photoMemory => JournalEntryTypes.memory,
  };

  bool get startFavorite => this == JournalTemplate.favoriteMoment;

  bool get openPhotoPicker => this == JournalTemplate.photoMemory;

  /// "Something funny" deep-links to funny-moment editor instead.
  bool get opensFunnyMoment => this == JournalTemplate.somethingFunny;
}
