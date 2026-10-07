import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/notifications/notification_channels.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Local notification engine foundation.
class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    AppLogger? logger,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _logger = logger ?? AppLogger.instance;

  final FlutterLocalNotificationsPlugin _plugin;
  final AppLogger _logger;
  bool _initialized = false;
  String _timezoneId = 'UTC';

  bool get isInitialized => _initialized;
  String get timezoneId => _timezoneId;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<void> initialize({bool requestIosPermissions = false}) async {
    if (_initialized) return;

    await configureTimeZone();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings(
      requestAlertPermission: requestIosPermissions,
      requestBadgePermission: requestIosPermissions,
      requestSoundPermission: requestIosPermissions,
    );
    final settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
    await _createAndroidChannels();

    _initialized = true;
    _logger.info('Notification service initialized');
  }

  /// Re-reads device timezone (call after OS timezone changes / app resume).
  Future<void> configureTimeZone() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      _timezoneId = info.identifier;
      tz.setLocalLocation(tz.getLocation(info.identifier));
      _logger.debug('Timezone configured', {'tz': info.identifier});
    } catch (error) {
      _timezoneId = 'UTC';
      tz.setLocalLocation(tz.UTC);
      _logger.warn('Timezone fallback to UTC', {
        'errorType': error.runtimeType.toString(),
      });
    }
  }

  /// Point-of-use iOS / Android 13+ notification permission request.
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final result = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final result = await android?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime whenLocal,
    required AndroidNotificationChannel channel,
    bool repeatsDaily = false,
  }) async {
    if (!_initialized) await initialize();

    var scheduled = tz.TZDateTime.from(whenLocal, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    if (!repeatsDaily && !scheduled.isAfter(now)) {
      _logger.debug('Skip past notification', {
        'id': id,
        'when': whenLocal.toIso8601String(),
      });
      return;
    }
    if (repeatsDaily && !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: repeatsDaily ? DateTimeComponents.time : null,
    );
    _logger.debug('Notification scheduled', {
      'id': id,
      'tz': _timezoneId,
      'when': scheduled.toIso8601String(),
    });
  }

  Future<void> cancel(int id) => _plugin.cancel(id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> _createAndroidChannels() async {
    if (!Platform.isAndroid) return;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    for (final channel in NotificationChannels.all) {
      await android.createNotificationChannel(channel);
    }
  }
}
