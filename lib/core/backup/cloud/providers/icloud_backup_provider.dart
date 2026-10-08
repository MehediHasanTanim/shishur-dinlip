import 'dart:io';

import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// iCloud Drive placeholder — see `docs/plan/icloud_backup_evaluation.md`.
///
/// Flutter cannot use CloudKit / NSFileManager ubiquity containers without
/// native iOS plugins and Apple entitlements. This provider stays in the
/// [BackupProvider] registry so UI can surface the evaluation outcome.
class ICloudBackupProvider extends BackupProvider {
  ICloudBackupProvider();

  static const evaluationSummary =
      'iCloud Drive requires an iOS-native ubiquity-container (or CloudKit) '
      'plugin, App Store entitlements, and careful conflict handling. Not '
      'shipped in this Flutter sprint; prefer Drive / OneDrive / Dropbox '
      'or Files share sheet on iOS for now.';

  @override
  BackupProviderId get id => BackupProviderId.iCloud;

  @override
  String get name => 'icloud';

  @override
  bool get isConfigured => false;

  @override
  bool get isSupported => false;

  @override
  Future<bool> isSignedIn() async => false;

  @override
  Future<void> connect() async {
    throw const BackupFailure(
      message:
          'iCloud backup is not available yet. See the iCloud evaluation notes.',
    );
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<RemoteBackup> upload(BackupUploadFile file) async {
    throw const BackupFailure(message: 'iCloud backup is not available yet.');
  }

  @override
  Future<List<RemoteBackup>> list() async => const [];

  @override
  Future<File> download(
    RemoteBackup backup, {
    required Directory toDirectory,
  }) async {
    throw const BackupFailure(message: 'iCloud backup is not available yet.');
  }

  @override
  Future<void> delete(RemoteBackup backup) async {
    throw const BackupFailure(message: 'iCloud backup is not available yet.');
  }
}
