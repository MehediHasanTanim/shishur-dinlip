import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

/// App-private filesystem layout and helpers.
class FileStorageService {
  FileStorageService({
    this.rootOverride,
    IdGenerator? ids,
    AppLogger? logger,
  }) : _ids = ids ?? idGenerator,
       _logger = logger ?? AppLogger.instance;

  final Directory? rootOverride;
  final IdGenerator _ids;
  final AppLogger _logger;
  Directory? _root;

  Future<Directory> ensureBootstrapped() async {
    if (_root != null) return _root!;
    if (rootOverride != null) {
      _root = rootOverride;
    } else {
      final support = await getApplicationSupportDirectory();
      _root = Directory(p.join(support.path, 'shishur_files'));
    }
    for (final relative in _relativeDirs) {
      await _ensure(Directory(p.join(_root!.path, relative)));
    }
    _logger.info('File storage bootstrapped');
    return _root!;
  }

  static const _relativeDirs = [
    'media/images',
    'media/videos',
    'media/audio',
    'media/thumbnails',
    'media/documents',
    'exports/pdf',
    'exports/album_images',
    'backups',
    'temp',
  ];

  Future<Directory> imagesDir() => _subdir('media/images');
  Future<Directory> videosDir() => _subdir('media/videos');
  Future<Directory> audioDir() => _subdir('media/audio');
  Future<Directory> thumbnailsDir() => _subdir('media/thumbnails');
  Future<Directory> documentsDir() => _subdir('media/documents');
  Future<Directory> pdfExportsDir() => _subdir('exports/pdf');
  Future<Directory> albumImagesDir() => _subdir('exports/album_images');
  Future<Directory> backupsDir() => _subdir('backups');
  Future<Directory> tempDir() => _subdir('temp');

  /// Builds a stable unique filename: `{uuid}{ext}`.
  String buildFileName({String? originalName, String? preferredExtension}) {
    final ext =
        preferredExtension ??
        (originalName == null || originalName.isEmpty
            ? ''
            : p.extension(originalName).toLowerCase());
    final normalized = ext.isEmpty
        ? ''
        : (ext.startsWith('.') ? ext : '.$ext');
    return '${_ids.next()}$normalized';
  }

  Future<File> absoluteFile(String relativeOrAbsolutePath) async {
    final root = await ensureBootstrapped();
    if (p.isAbsolute(relativeOrAbsolutePath)) {
      return File(relativeOrAbsolutePath);
    }
    return File(p.join(root.path, relativeOrAbsolutePath));
  }

  String toRelativePath(String absolutePath) {
    final root = _root;
    if (root == null) return absolutePath;
    return p.relative(absolutePath, from: root.path);
  }

  /// Writes bytes via temp file then rename for crash-safer persistence.
  Future<File> writeBytesAtomic({
    required Directory directory,
    required String fileName,
    required List<int> bytes,
  }) async {
    await ensureBootstrapped();
    final target = File(p.join(directory.path, fileName));
    final temp = File('${target.path}.tmp');
    try {
      await temp.writeAsBytes(bytes, flush: true);
      if (await target.exists()) {
        await target.delete();
      }
      return await temp.rename(target.path);
    } catch (error, stackTrace) {
      _logger.error(
        'Atomic write failed',
        error: error,
        stackTrace: stackTrace,
        fields: {'fileName': fileName},
      );
      if (await temp.exists()) {
        await temp.delete();
      }
      throw FileFailure(cause: error);
    }
  }

  Future<File> copyIntoAtomic({
    required File source,
    required Directory directory,
    required String fileName,
  }) async {
    final bytes = await source.readAsBytes();
    return writeBytesAtomic(
      directory: directory,
      fileName: fileName,
      bytes: bytes,
    );
  }

  Future<void> cleanupTemp({
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final dir = await tempDir();
    final cutoff = DateTime.now().subtract(maxAge);
    var removed = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final stat = await entity.stat();
      if (stat.modified.isBefore(cutoff)) {
        await entity.delete();
        removed++;
      }
    }
    _logger.info('Temp cleanup complete', {'removed': removed});
  }

  Future<void> deleteIfExists(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = await absoluteFile(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Uint8List> readBytes(String path) async {
    final file = await absoluteFile(path);
    if (!await file.exists()) {
      throw const FileFailure(message: 'File is no longer available.');
    }
    return file.readAsBytes();
  }

  Future<Directory> _subdir(String relative) async {
    final root = await ensureBootstrapped();
    return _ensure(Directory(p.join(root.path, relative)));
  }

  Future<Directory> _ensure(Directory dir) async {
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
