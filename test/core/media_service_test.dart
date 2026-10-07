import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';

void main() {
  late Directory tempRoot;
  late AppDatabase db;
  late FileStorageService storage;
  late MediaService mediaService;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('sd_media_');
    db = AppDatabase.memory();
    storage = FileStorageService(rootOverride: tempRoot);
    await storage.ensureBootstrapped();
    mediaService = MediaService(db, storage: storage);
  });

  tearDown(() async {
    await db.close();
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  Future<File> writeSamplePng() async {
    final image = img.Image(width: 64, height: 48);
    img.fill(image, color: img.ColorRgb8(10, 120, 80));
    final bytes = Uint8List.fromList(img.encodePng(image));
    final file = File(p.join(tempRoot.path, 'sample.png'));
    await file.writeAsBytes(bytes);
    return file;
  }

  test('imports image with checksum and thumbnail', () async {
    final source = await writeSamplePng();
    final asset = await mediaService.importImage(
      sourceFile: source,
      originalFilename: 'sample.png',
      childId: 'child-1',
    );

    expect(asset.checksum, isNotEmpty);
    expect(asset.width, 64);
    expect(asset.height, 48);
    expect(asset.thumbnailPath, isNotNull);
    expect(asset.fileSizeBytes, greaterThan(0));

    final stored = await storage.absoluteFile(asset.localPath);
    expect(await stored.exists(), isTrue);

    final thumb = await storage.absoluteFile(asset.thumbnailPath!);
    expect(await thumb.exists(), isTrue);
  });

  test('broken file throws FileFailure', () async {
    final broken = File(p.join(tempRoot.path, 'broken.png'));
    await broken.writeAsBytes([1, 2, 3, 4, 5]);

    expect(
      () => mediaService.importImage(sourceFile: broken),
      throwsA(isA<FileFailure>()),
    );
  });

  test('checksum generation is stable', () async {
    final source = await writeSamplePng();
    final a = await mediaService.checksumForFile(source);
    final b = await mediaService.checksumForFile(source);
    expect(a, b);
  });

  test('delete unused media removes files', () async {
    final source = await writeSamplePng();
    final asset = await mediaService.importImage(sourceFile: source);
    final stored = await storage.absoluteFile(asset.localPath);
    expect(await stored.exists(), isTrue);

    await mediaService.deleteUnusedMediaSafely(asset.id);
    expect(await stored.exists(), isFalse);
    expect(await db.mediaAssetsDao.getById(asset.id), isNull);
  });
}
