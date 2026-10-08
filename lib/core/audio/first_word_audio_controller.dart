import 'dart:async';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';

/// Records and plays first-word audio clips stored as [MediaAsset]s.
class FirstWordAudioController {
  FirstWordAudioController({
    required this.permissions,
    required this.storage,
    required this.media,
  });

  final PermissionService permissions;
  final FileStorageService storage;
  final MediaService media;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  File? pendingFile;
  int? pendingDurationMs;
  String? savedAssetId;
  MediaAsset? savedAsset;

  var isRecording = false;
  var isPlaying = false;
  DateTime? _recordStartedAt;

  StreamSubscription<PlayerState>? _playerSub;
  void Function()? onChanged;

  Future<void> loadSavedAsset(String? assetId) async {
    savedAssetId = assetId;
    savedAsset = null;
    pendingFile = null;
    pendingDurationMs = null;
    if (assetId == null || assetId.isEmpty) return;
    savedAsset = await media.getById(assetId);
  }

  bool get hasAudio =>
      pendingFile != null ||
      (savedAssetId != null && savedAssetId!.isNotEmpty);

  Future<void> startRecording() async {
    final allowed = await permissions.ensure(AppPermission.microphone);
    if (!allowed) {
      throw const PermissionFailure(
        message: 'Microphone permission is required to record audio.',
      );
    }
    if (isRecording) return;
    await stopPlayback();

    await storage.ensureBootstrapped();
    final temp = await storage.tempDir();
    final path = p.join(
      temp.path,
      'first_word_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
    isRecording = true;
    _recordStartedAt = DateTime.now();
    onChanged?.call();
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;
    final path = await _recorder.stop();
    isRecording = false;
    final started = _recordStartedAt;
    _recordStartedAt = null;
    if (path == null || path.isEmpty) {
      onChanged?.call();
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      onChanged?.call();
      return;
    }
    pendingFile = file;
    pendingDurationMs = started == null
        ? null
        : DateTime.now().difference(started).inMilliseconds;
    onChanged?.call();
  }

  Future<void> cancelRecording() async {
    if (isRecording) {
      await _recorder.cancel();
      isRecording = false;
      _recordStartedAt = null;
      onChanged?.call();
    }
  }

  Future<void> play() async {
    final file = await _resolvePlayableFile();
    if (file == null) return;
    await stopPlayback();
    await _playerSub?.cancel();
    await _player.setFilePath(file.path);
    _playerSub = _player.playerStateStream.listen((state) {
      isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
      }
      onChanged?.call();
    });
    await _player.play();
    isPlaying = true;
    onChanged?.call();
  }

  Future<void> stopPlayback() async {
    if (_player.playing) {
      await _player.stop();
    }
    isPlaying = false;
    onChanged?.call();
  }

  Future<void> clearAudio({required bool deleteSavedAsset}) async {
    await cancelRecording();
    await stopPlayback();
    pendingFile = null;
    pendingDurationMs = null;
    if (deleteSavedAsset &&
        savedAssetId != null &&
        savedAssetId!.isNotEmpty) {
      await media.deleteMediaAsset(savedAssetId!);
    }
    savedAssetId = null;
    savedAsset = null;
    onChanged?.call();
  }

  /// Persists a pending recording (if any) and returns the asset id to store.
  Future<String?> persistPending({String? childId}) async {
    final pending = pendingFile;
    if (pending == null) return savedAssetId;

    final asset = await media.importAudio(
      sourceFile: pending,
      childId: childId,
      originalFilename: p.basename(pending.path),
      durationMs: pendingDurationMs,
      capturedAt: DateTime.now().toUtc(),
    );

    if (savedAssetId != null &&
        savedAssetId!.isNotEmpty &&
        savedAssetId != asset.id) {
      await media.deleteMediaAsset(savedAssetId!);
    }

    try {
      if (await pending.exists()) await pending.delete();
    } catch (_) {}

    pendingFile = null;
    pendingDurationMs = null;
    savedAssetId = asset.id;
    savedAsset = asset;
    onChanged?.call();
    return asset.id;
  }

  Future<File?> _resolvePlayableFile() async {
    if (pendingFile != null && await pendingFile!.exists()) {
      return pendingFile;
    }
    final asset = savedAsset;
    if (asset == null) return null;
    final file = await storage.absoluteFile(asset.localPath);
    if (!await file.exists()) return null;
    return file;
  }

  Future<void> dispose() async {
    await cancelRecording();
    await stopPlayback();
    await _playerSub?.cancel();
    await _recorder.dispose();
    await _player.dispose();
  }
}
