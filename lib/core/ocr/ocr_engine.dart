import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';

/// Local on-device text recognition seam.
abstract class OcrEngine {
  String get name;

  Future<OcrRawResult> recognize(File imageFile);

  Future<void> dispose() async {}
}

/// Google ML Kit text recognition (on-device; no network).
class MlKitOcrEngine extends OcrEngine {
  MlKitOcrEngine({
    this.script = TextRecognitionScript.latin,
    TextRecognizer? recognizer,
  }) : _recognizer = recognizer ?? TextRecognizer(script: script);

  final TextRecognitionScript script;
  final TextRecognizer _recognizer;

  @override
  String get name => 'mlkit_${script.name}';

  @override
  Future<OcrRawResult> recognize(File imageFile) async {
    if (!await imageFile.exists()) {
      throw const ValidationFailure(message: 'Scan image was not found.');
    }
    try {
      final input = InputImage.fromFilePath(imageFile.path);
      final recognized = await _recognizer.processImage(input);
      final blocks = <OcrTextBlock>[];
      var cursor = 0;
      final buffer = StringBuffer();
      for (final block in recognized.blocks) {
        final text = block.text.trim();
        if (text.isEmpty) continue;
        if (buffer.isNotEmpty) {
          buffer.writeln();
          cursor += 1;
        }
        final start = cursor;
        buffer.write(text);
        cursor += text.length;
        blocks.add(OcrTextBlock(text: text, start: start, end: cursor));
      }
      return OcrRawResult(
        fullText: buffer.toString(),
        blocks: blocks,
        engineName: name,
      );
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'OCR recognition failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw ValidationFailure(
        message: 'Could not read text from this image.',
        cause: error,
      );
    }
  }

  @override
  Future<void> dispose() => _recognizer.close();
}

/// Deterministic engine for tests and desktop fallbacks.
class FakeOcrEngine extends OcrEngine {
  FakeOcrEngine({this.scriptedText});

  /// When set, always returns this text.
  final String? scriptedText;

  @override
  String get name => 'fake';

  @override
  Future<OcrRawResult> recognize(File imageFile) async {
    final text = scriptedText ??
        await _tryReadSidecar(imageFile) ??
        'No OCR text available in this test environment.';
    return OcrRawResult(
      fullText: text,
      blocks: [
        OcrTextBlock(text: text, start: 0, end: text.length),
      ],
      engineName: name,
    );
  }

  Future<String?> _tryReadSidecar(File imageFile) async {
    final sidecar = File('${imageFile.path}.ocr.txt');
    if (await sidecar.exists()) {
      return sidecar.readAsString();
    }
    return null;
  }
}
