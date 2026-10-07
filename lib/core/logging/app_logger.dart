import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';

/// Privacy-safe logger.
///
/// Never log journal text, health notes, child photos, or file contents.
class AppLogger {
  const AppLogger._();

  static const AppLogger instance = AppLogger._();

  static const _sensitiveKeys = {
    'name',
    'nickname',
    'child',
    'children',
    'journal',
    'story',
    'note',
    'notes',
    'body',
    'quote',
    'letter',
    'caption',
    'diagnosis',
    'symptom',
    'symptoms',
    'medicine',
    'prescription',
    'photo',
    'path',
    'file',
    'password',
    'passphrase',
    'pin',
    'token',
    'key',
    'secret',
    'backup',
  };

  void debug(String message, [Map<String, Object?>? fields]) {
    if (!_enabled) return;
    _print('DEBUG', message, fields);
  }

  void info(String message, [Map<String, Object?>? fields]) {
    if (!_enabled) return;
    _print('INFO', message, fields);
  }

  void warn(String message, [Map<String, Object?>? fields]) {
    if (!_enabled) return;
    _print('WARN', message, fields);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? fields,
  }) {
    if (!_enabled) return;
    final merged = <String, Object?>{
      ...?fields,
      if (error != null) 'errorType': error.runtimeType.toString(),
    };
    _print('ERROR', message, merged);
    if (kDebugMode && stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  bool get _enabled {
    try {
      return AppConfig.current.enableDebugLogging || kDebugMode;
    } catch (_) {
      return kDebugMode;
    }
  }

  void _print(String level, String message, Map<String, Object?>? fields) {
    final safe = fields == null ? '' : ' ${_redact(fields)}';
    debugPrint('[ShishurDinlipi][$level] $message$safe');
  }

  Map<String, Object?> _redact(Map<String, Object?> fields) {
    return fields.map((key, value) {
      final lower = key.toLowerCase();
      final sensitive = _sensitiveKeys.any(lower.contains);
      if (sensitive) return MapEntry(key, '***');
      if (value is String && value.length > 120) {
        return MapEntry(key, '${value.substring(0, 24)}…');
      }
      return MapEntry(key, value);
    });
  }
}
