import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

/// Applies Android FLAG_SECURE to block screenshots / recents previews.
abstract final class FlagSecure {
  static const _channel = MethodChannel('com.shishurdinlipi.app/flag_secure');

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('setFlagSecure', {'enabled': enabled});
    } on PlatformException catch (e) {
      AppLogger.instance.warn('FLAG_SECURE failed', {
        'code': e.code,
        'errorType': e.runtimeType.toString(),
      });
    } on MissingPluginException {
      // Tests / platforms without the channel.
    }
  }
}
