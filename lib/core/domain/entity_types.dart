/// Polymorphic link tokens for [attachments] and [tag_links].
abstract final class EntityTypes {
  static const journalEntry = 'journal_entry';
  static const funnyMoment = 'funny_moment';
  static const achievement = 'achievement';
  static const milestone = 'milestone';
  static const firstWord = 'first_word';
  static const growthRecord = 'growth_record';
  static const schoolProfile = 'school_profile';
  static const schoolEvent = 'school_event';
  static const vaccination = 'vaccination';
  static const illnessEpisode = 'illness_episode';
  static const medicine = 'medicine';
  static const doctorVisit = 'doctor_visit';
  static const medicalDocument = 'medical_document';
  static const mediaAsset = 'media_asset';
  static const album = 'album';
  static const birthday = 'birthday';
  static const favorite = 'favorite';
  static const interest = 'interest';
  static const familyEvent = 'family_event';
  static const trip = 'trip';
}

abstract final class JournalEntryTypes {
  static const general = 'general';
  static const proudMoment = 'proud_moment';
  static const difficultDay = 'difficult_day';
  static const familyEvent = 'family_event';
  static const trip = 'trip';
  static const memory = 'memory';
  static const reflection = 'reflection';
}

abstract final class JournalMoods {
  static const happy = 'happy';
  static const calm = 'calm';
  static const proud = 'proud';
  static const silly = 'silly';
  static const tired = 'tired';
  static const sad = 'sad';
  static const grateful = 'grateful';
}

abstract final class AchievementCategories {
  static const school = 'school';
  static const sports = 'sports';
  static const arts = 'arts';
  static const social = 'social';
  static const personal = 'personal';
  static const other = 'other';
}
