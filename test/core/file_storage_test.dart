import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';

void main() {
  late Directory root;
  late FileStorageService storage;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('sd_files_');
    storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
  });

  tearDown(() async {
    if (await root.exists()) {
      await root.delete(recursive: true);
    }
  });

  test('bootstraps required directories', () async {
    final images = await storage.imagesDir();
    final videos = await storage.videosDir();
    final audio = await storage.audioDir();
    final thumbs = await storage.thumbnailsDir();
    final docs = await storage.documentsDir();
    final pdf = await storage.pdfExportsDir();
    final albums = await storage.albumImagesDir();
    final backups = await storage.backupsDir();
    final temp = await storage.tempDir();

    for (final dir in [
      images,
      videos,
      audio,
      thumbs,
      docs,
      pdf,
      albums,
      backups,
      temp,
    ]) {
      expect(await dir.exists(), isTrue);
    }
  });

  test('atomic write creates final file', () async {
    final dir = await storage.tempDir();
    final file = await storage.writeBytesAtomic(
      directory: dir,
      fileName: 'atomic.bin',
      bytes: Uint8List.fromList([9, 8, 7]),
    );
    expect(await file.exists(), isTrue);
    expect(await file.readAsBytes(), [9, 8, 7]);
    expect(await File('${file.path}.tmp').exists(), isFalse);
  });

  test('temp cleanup removes old files', () async {
    final dir = await storage.tempDir();
    final oldFile = File(p.join(dir.path, 'old.tmp'));
    await oldFile.writeAsBytes([1]);
    await oldFile.setLastModified(
      DateTime.now().subtract(const Duration(days: 2)),
    );

    await storage.cleanupTemp(maxAge: const Duration(hours: 1));
    expect(await oldFile.exists(), isFalse);
  });
}
