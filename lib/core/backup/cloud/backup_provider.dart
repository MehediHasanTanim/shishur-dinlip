import 'dart:io';

import 'package:flutter/foundation.dart';

/// Identifiers for optional cloud / local backup destinations.
enum BackupProviderId {
  local,
  googleDrive,
  oneDrive,
  dropbox,
  iCloud,
}

@immutable
class BackupUploadFile {
  const BackupUploadFile({
    required this.absolutePath,
    required this.fileName,
    this.byteSize,
    this.createdAt,
  });

  final String absolutePath;
  final String fileName;
  final int? byteSize;
  final DateTime? createdAt;

  File get file => File(absolutePath);
}

@immutable
class RemoteBackup {
  const RemoteBackup({
    required this.id,
    required this.fileName,
    required this.providerId,
    required this.createdAt,
    required this.byteSize,
    this.remotePath,
  });

  final String id;
  final String fileName;
  final BackupProviderId providerId;
  final DateTime createdAt;
  final int byteSize;
  final String? remotePath;
}

/// Common facade for local + cloud encrypted `.sdjbackup` packages.
///
/// Cloud providers keep tokens in secure storage and upload only already-
/// encrypted packages produced by [BackupService].
abstract class BackupProvider {
  BackupProviderId get id;

  /// Stable English key used for logs / settings (not UI copy).
  String get name;

  /// True when OAuth client IDs (or platform support) are present.
  bool get isConfigured;

  /// iCloud and similar may be evaluated but not shippable yet.
  bool get isSupported => true;

  Future<bool> isSignedIn();

  /// Starts OAuth (or no-op for local). Throws [BackupFailure] if unavailable.
  Future<void> connect();

  Future<void> disconnect();

  Future<RemoteBackup> upload(BackupUploadFile file);

  Future<List<RemoteBackup>> list();

  Future<File> download(
    RemoteBackup backup, {
    required Directory toDirectory,
  });

  Future<void> delete(RemoteBackup backup);
}
