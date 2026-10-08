import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/models/first_word.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/repository/first_words_repository.dart';

void main() {
  late Directory root;
  late AppDatabase db;
  late FileStorageService storage;
  late MediaService media;
  late DriftFirstWordsRepository words;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('sd_audio_');
    db = AppDatabase.memory();
    storage = FileStorageService(rootOverride: root);
    await storage.ensureBootstrapped();
    media = MediaService(db, storage: storage);
    words = DriftFirstWordsRepository(db);
  });

  tearDown(() async {
    await db.close();
    if (await root.exists()) {
      await root.delete(recursive: true);
    }
  });

  test('importAudio stores MediaAssetType.audio under media/audio', () async {
    final source = File(p.join(root.path, 'clip.m4a'));
    await source.writeAsBytes(Uint8List.fromList(List.filled(64, 7)));

    final asset = await media.importAudio(
      sourceFile: source,
      childId: 'child-1',
      durationMs: 1200,
    );

    expect(asset.assetType, MediaAssetType.audio);
    expect(asset.mimeType, 'audio/mp4');
    expect(asset.durationMs, 1200);
    expect(asset.localPath, startsWith('media/audio/'));
    expect(await (await storage.absoluteFile(asset.localPath)).exists(), isTrue);

    final loaded = await media.getById(asset.id);
    expect(loaded?.id, asset.id);
  });

  test('first word save links audioAssetId and clears placeholder legacy', () async {
    final source = File(p.join(root.path, 'mama.m4a'));
    await source.writeAsBytes(Uint8List.fromList(List.filled(32, 1)));
    final asset = await media.importAudio(sourceFile: source);

    final now = DateTime.now().toUtc();
    final saved = await words.save(
      FirstWord(
        id: '',
        childId: 'child-1',
        word: 'Mama',
        datePrecision: DatePrecision.exact,
        eventDate: DateTime(2024, 1, 1),
        audioAssetId: asset.id,
        audioPlaceholder: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(saved.audioAssetId, asset.id);
    expect(saved.audioPlaceholder, isTrue);

    final cleared = await words.save(
      saved.copyWith(
        clearAudioAssetId: true,
        audioPlaceholder: false,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    expect(cleared.audioAssetId, isNull);
    expect(cleared.audioPlaceholder, isFalse);
  });
}
