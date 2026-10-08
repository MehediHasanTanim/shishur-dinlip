import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_registry.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';

/// High-level helpers: upload local packages, list/download/delete remotes.
class CloudBackupService {
  CloudBackupService({
    required this.registry,
    required this.backupService,
    required this.storage,
  });

  final CloudBackupRegistry registry;
  final BackupService backupService;
  final FileStorageService storage;

  BackupProvider provider(BackupProviderId id) => registry.require(id);

  Future<RemoteBackup> uploadLocalFile({
    required BackupProviderId providerId,
    required String absolutePath,
    String? fileName,
  }) async {
    final provider = registry.require(providerId);
    if (!provider.isSupported) {
      throw const BackupFailure(message: 'This cloud provider is not supported.');
    }
    if (!provider.isConfigured) {
      throw const BackupFailure(
        message: 'Cloud backup is not configured for this build.',
      );
    }
    if (!await provider.isSignedIn()) {
      throw const BackupFailure(message: 'Sign in to the cloud provider first.');
    }
    final name = fileName ?? p.basename(absolutePath);
    final file = File(absolutePath);
    if (!await file.exists()) {
      throw const BackupFailure(message: 'Backup file was not found.');
    }
    final stat = await file.stat();
    return provider.upload(
      BackupUploadFile(
        absolutePath: absolutePath,
        fileName: name,
        byteSize: stat.size,
        createdAt: stat.modified.toUtc(),
      ),
    );
  }

  Future<RemoteBackup> uploadLatestLocal({
    required BackupProviderId providerId,
  }) async {
    final history = await backupService.listLocalHistory();
    if (history.isEmpty) {
      throw const BackupFailure(
        message: 'Create a local backup before uploading to the cloud.',
      );
    }
    final latest = history.first;
    return uploadLocalFile(
      providerId: providerId,
      absolutePath: latest.absolutePath,
      fileName: latest.fileName,
    );
  }

  Future<List<RemoteBackup>> list(BackupProviderId providerId) {
    return registry.require(providerId).list();
  }

  Future<File> downloadToTemp(RemoteBackup backup) async {
    final temp = await storage.tempDir();
    final dir = Directory(
      p.join(temp.path, 'cloud_dl_${backup.providerId.name}'),
    );
    return registry.require(backup.providerId).download(
          backup,
          toDirectory: dir,
        );
  }

  Future<void> deleteRemote(RemoteBackup backup) {
    return registry.require(backup.providerId).delete(backup);
  }
}
