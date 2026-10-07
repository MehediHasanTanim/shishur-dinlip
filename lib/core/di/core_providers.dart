import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/notifications/notification_id_store.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/achievements_repository.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/funny_moments_repository.dart';
import 'package:shishur_dinlipi/core/repository/journal_repository.dart';
import 'package:shishur_dinlipi/core/repository/tags_repository.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';
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
