import 'dart:io';

import 'package:shishur_dinlipi/core/files/file_storage_service.dart';

/// Backward-compatible facade over [FileStorageService].
@Deprecated('Use FileStorageService instead')
class AppFilePaths {
  AppFilePaths({FileStorageService? storage})
    : _storage = storage ?? FileStorageService();

  final FileStorageService _storage;

  Future<Directory> supportDir() => _storage.ensureBootstrapped();
  Future<Directory> photosDir() => _storage.imagesDir();
  Future<Directory> documentsDir() => _storage.documentsDir();
  Future<Directory> backupsDir() => _storage.backupsDir();
  Future<Directory> exportsDir() => _storage.pdfExportsDir();
  Future<Directory> tempDir() => _storage.tempDir();
}
