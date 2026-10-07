import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/app/app.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';

Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(flavor);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final database = AppDatabase.native();
  final fileStorage = FileStorageService();
  await fileStorage.ensureBootstrapped();
  await fileStorage.cleanupTemp();

  final notifications = NotificationService();
  try {
    await notifications.initialize();
  } catch (error, stackTrace) {
    AppLogger.instance.error(
      'Notification init skipped',
      error: error,
      stackTrace: stackTrace,
    );
  }

  AppLogger.instance.info('Bootstrapping app', {'flavor': flavor.name});

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        fileStorageServiceProvider.overrideWithValue(fileStorage),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const ShishurDinlipiApp(),
    ),
  );
}
