import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/app/router/app_router.dart';
import 'package:shishur_dinlipi/app/theme/app_theme.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_bootstrap.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class ShishurDinlipiApp extends ConsumerWidget {
  const ShishurDinlipiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final router = ref.watch(appRouterProvider);
    final config = AppConfig.current;

    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.showFlavorBanner,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) {
        if (settingsAsync.isLoading) {
          return const Material(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ReminderBootstrap(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
