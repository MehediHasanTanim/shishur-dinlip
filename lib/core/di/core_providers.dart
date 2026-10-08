import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/photos/photo_library_service.dart';
import 'package:shishur_dinlipi/core/repository/achievements_repository.dart';
import 'package:shishur_dinlipi/core/repository/albums_repository.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/birthdays_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/family_events_repository.dart';
import 'package:shishur_dinlipi/core/repository/favorites_repository.dart';
import 'package:shishur_dinlipi/core/repository/interests_repository.dart';
import 'package:shishur_dinlipi/core/repository/trips_repository.dart';
import 'package:shishur_dinlipi/core/repository/doctor_visits_repository.dart';
import 'package:shishur_dinlipi/core/repository/first_words_repository.dart';
import 'package:shishur_dinlipi/core/repository/funny_moments_repository.dart';
import 'package:shishur_dinlipi/core/repository/growth_repository.dart';
import 'package:shishur_dinlipi/core/repository/illness_episodes_repository.dart';
import 'package:shishur_dinlipi/core/repository/journal_repository.dart';
import 'package:shishur_dinlipi/core/repository/medical_documents_repository.dart';
import 'package:shishur_dinlipi/core/repository/medicines_repository.dart';
import 'package:shishur_dinlipi/core/repository/milestones_repository.dart';
import 'package:shishur_dinlipi/core/repository/reminders_repository.dart';
import 'package:shishur_dinlipi/core/repository/school_events_repository.dart';
import 'package:shishur_dinlipi/core/repository/school_profiles_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';
import 'package:shishur_dinlipi/core/repository/vaccinations_repository.dart';
import 'package:shishur_dinlipi/core/repository/year_review_preferences_repository.dart';
import 'package:shishur_dinlipi/core/search/recent_searches_store.dart';
import 'package:shishur_dinlipi/core/search/search_service.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';
import 'package:shishur_dinlipi/core/timeline/timeline_service.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_query_service.dart';
import 'package:shishur_dinlipi/core/pdf/birthday_pdf_generator.dart';
import 'package:shishur_dinlipi/core/pdf/year_review_pdf_generator.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/backup/restore_service.dart';
import 'package:shishur_dinlipi/core/security/biometric_service.dart';
import 'package:shishur_dinlipi/core/security/db_encryption_key_store.dart';
import 'package:shishur_dinlipi/core/security/pin_service.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';
import 'package:shishur_dinlipi/core/security/security_settings_store.dart';
import 'package:shishur_dinlipi/core/storage/storage_management_service.dart';
import 'package:shishur_dinlipi/features/children/profile_photo_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in bootstrap',
  );
});

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

final childrenRepositoryProvider = Provider<ChildrenRepository>((ref) {
  return DriftChildrenRepository(ref.watch(appDatabaseProvider));
});

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService(
    ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError(
    'notificationServiceProvider must be overridden in bootstrap',
  );
});

final notificationIdStoreProvider = Provider<NotificationIdStore>((ref) {
  return NotificationIdStore(ref.watch(appDatabaseProvider));
});

final profilePhotoServiceProvider = Provider<ProfilePhotoService>((ref) {
  return ProfilePhotoService(
    mediaService: ref.watch(mediaServiceProvider),
    childrenRepository: ref.watch(childrenRepositoryProvider),
    fileStorage: ref.watch(fileStorageServiceProvider),
    permissions: ref.watch(permissionServiceProvider),
  );
});

final attachmentRepositoryProvider = Provider<AttachmentRepository>((ref) {
  return DriftAttachmentRepository(
    ref.watch(appDatabaseProvider),
    mediaService: ref.watch(mediaServiceProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return DriftTagsRepository(ref.watch(appDatabaseProvider));
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return DriftJournalRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
    tags: ref.watch(tagsRepositoryProvider),
  );
});

final funnyMomentsRepositoryProvider = Provider<FunnyMomentsRepository>((ref) {
  return DriftFunnyMomentsRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  return DriftAchievementsRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final growthRepositoryProvider = Provider<GrowthRepository>((ref) {
  return DriftGrowthRepository(ref.watch(appDatabaseProvider));
});

final milestonesRepositoryProvider = Provider<MilestonesRepository>((ref) {
  return DriftMilestonesRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final firstWordsRepositoryProvider = Provider<FirstWordsRepository>((ref) {
  return DriftFirstWordsRepository(ref.watch(appDatabaseProvider));
});

final schoolProfilesRepositoryProvider = Provider<SchoolProfilesRepository>((
  ref,
) {
  return DriftSchoolProfilesRepository(ref.watch(appDatabaseProvider));
});

final schoolEventsRepositoryProvider = Provider<SchoolEventsRepository>((ref) {
  return DriftSchoolEventsRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final vaccinationsRepositoryProvider = Provider<VaccinationsRepository>((ref) {
  return DriftVaccinationsRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final illnessEpisodesRepositoryProvider = Provider<IllnessEpisodesRepository>((
  ref,
) {
  return DriftIllnessEpisodesRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final medicinesRepositoryProvider = Provider<MedicinesRepository>((ref) {
  return DriftMedicinesRepository(ref.watch(appDatabaseProvider));
});

final doctorVisitsRepositoryProvider = Provider<DoctorVisitsRepository>((ref) {
  return DriftDoctorVisitsRepository(
    ref.watch(appDatabaseProvider),
    attachments: ref.watch(attachmentRepositoryProvider),
  );
});

final medicalDocumentsRepositoryProvider =
    Provider<MedicalDocumentsRepository>((ref) {
      return DriftMedicalDocumentsRepository(
        ref.watch(appDatabaseProvider),
        media: ref.watch(mediaServiceProvider),
      );
    });

final timelineServiceProvider = Provider<TimelineService>((ref) {
  return TimelineService(ref.watch(appDatabaseProvider));
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return DriftRemindersRepository(
    ref.watch(appDatabaseProvider),
    notifications: ref.watch(notificationServiceProvider),
    idsStore: ref.watch(notificationIdStoreProvider),
    permissions: ref.watch(permissionServiceProvider),
  );
});

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(ref.watch(appDatabaseProvider));
});

final recentSearchesStoreProvider = Provider<RecentSearchesStore>((ref) {
  return RecentSearchesStore(ref.watch(appDatabaseProvider));
});

final photoLibraryServiceProvider = Provider<PhotoLibraryService>((ref) {
  return PhotoLibraryService(
    ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final albumsRepositoryProvider = Provider<AlbumsRepository>((ref) {
  return DriftAlbumsRepository(ref.watch(appDatabaseProvider));
});

final birthdaysRepositoryProvider = Provider<BirthdaysRepository>((ref) {
  return DriftBirthdaysRepository(ref.watch(appDatabaseProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return DriftFavoritesRepository(ref.watch(appDatabaseProvider));
});

final birthdayPdfGeneratorProvider = Provider<BirthdayPdfGenerator>((ref) {
  return BirthdayPdfGenerator(
    ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final interestsRepositoryProvider = Provider<InterestsRepository>((ref) {
  return DriftInterestsRepository(ref.watch(appDatabaseProvider));
});

final familyEventsRepositoryProvider = Provider<FamilyEventsRepository>((ref) {
  return DriftFamilyEventsRepository(ref.watch(appDatabaseProvider));
});

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  return DriftTripsRepository(ref.watch(appDatabaseProvider));
});

final yearReviewPreferencesRepositoryProvider =
    Provider<YearReviewPreferencesRepository>((ref) {
      return DriftYearReviewPreferencesRepository(
        ref.watch(appDatabaseProvider),
      );
    });

final yearReviewQueryServiceProvider = Provider<YearReviewQueryService>((ref) {
  return YearReviewQueryService(ref.watch(appDatabaseProvider));
});

final yearReviewPdfGeneratorProvider = Provider<YearReviewPdfGenerator>((ref) {
  return YearReviewPdfGenerator(
    ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final dbEncryptionKeyStoreProvider = Provider<DbEncryptionKeyStore>((ref) {
  return DbEncryptionKeyStore(ref.watch(secureStorageServiceProvider));
});

final pinServiceProvider = Provider<PinService>((ref) {
  return PinService(ref.watch(secureStorageServiceProvider));
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(ref.watch(secureStorageServiceProvider));
});

final securitySettingsStoreProvider = Provider<SecuritySettingsStore>((ref) {
  return SecuritySettingsStore(ref.watch(secureStorageServiceProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    db: ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});

final restoreServiceProvider = Provider<RestoreService>((ref) {
  return RestoreService(
    db: ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
    backupService: ref.watch(backupServiceProvider),
    reminders: ref.watch(remindersRepositoryProvider),
  );
});

final storageManagementServiceProvider = Provider<StorageManagementService>((
  ref,
) {
  return StorageManagementService(
    db: ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
  );
});
