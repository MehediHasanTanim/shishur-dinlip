import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';

/// Local encrypted backup folder — always available offline.
class LocalBackupProvider extends BackupProvider {
  LocalBackupProvider({
    required this.backupService,
    required this.storage,
  });

  final BackupService backupService;
  final FileStorageService storage;

  @override
  BackupProviderId get id => BackupProviderId.local;

  @override
  String get name => 'local';

  @override
  bool get isConfigured => true;

  @override
  Future<bool> isSignedIn() async => true;

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<RemoteBackup> upload(BackupUploadFile file) async {
    final source = file.file;
    if (!await source.exists()) {
      throw const BackupFailure(message: 'Backup file was not found.');
    }
    final dir = await storage.backupsDir();
    final destPath = p.join(dir.path, file.fileName);
    if (p.normalize(source.path) != p.normalize(destPath)) {
      await source.copy(destPath);
    }
    final stat = await File(destPath).stat();
    return RemoteBackup(
      id: p.basenameWithoutExtension(file.fileName),
      fileName: file.fileName,
      providerId: id,
      createdAt: file.createdAt ?? stat.modified.toUtc(),
      byteSize: file.byteSize ?? stat.size,
      remotePath: destPath,
    );
  }

  @override
  Future<List<RemoteBackup>> list() async {
    final history = await backupService.listLocalHistory();
    return history
        .map(
          (e) => RemoteBackup(
            id: e.id,
            fileName: e.fileName,
            providerId: id,
            createdAt: e.createdAt,
            byteSize: e.byteSize,
            remotePath: e.absolutePath,
          ),
        )
        .toList();
  }

  @override
  Future<File> download(
    RemoteBackup backup, {
    required Directory toDirectory,
  }) async {
    final path = backup.remotePath;
    if (path == null || path.isEmpty) {
      throw const BackupFailure(message: 'Local backup path missing.');
    }
    final source = File(path);
    if (!await source.exists()) {
      throw const BackupFailure(message: 'Local backup file was not found.');
    }
    await toDirectory.create(recursive: true);
    final dest = File(p.join(toDirectory.path, backup.fileName));
    return source.copy(dest.path);
  }

  @override
  Future<void> delete(RemoteBackup backup) async {
    final path = backup.remotePath;
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
