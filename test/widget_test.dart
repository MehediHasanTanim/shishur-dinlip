import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/app/app.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/notifications/notification_service.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    AppConfig.initialize(AppFlavor.dev);
    db = AppDatabase.memory();
    await SettingsRepository(db).save(
      const AppSettings(
        language: AppLanguage.english,
        themeMode: ThemeMode.light,
        onboardingComplete: true,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('app shell reaches home after splash redirect', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          fileStorageServiceProvider.overrideWithValue(FileStorageService()),
          notificationServiceProvider.overrideWithValue(NotificationService()),
        ],
        child: const ShishurDinlipiApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Home'), findsWidgets);
  });

  testWidgets('localizations expose database error copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: SizedBox.shrink(),
      ),
    );

    final context = tester.element(find.byType(SizedBox));
    final l10n = AppLocalizations.of(context);
    expect(l10n.errorDatabase, contains('database'));
  });
}
