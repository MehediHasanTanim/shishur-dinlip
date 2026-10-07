import 'package:shishur_dinlipi/core/config/app_flavor.dart';

/// Compile-time / flavor-level configuration.
///
/// Values differ per [AppFlavor] so logging, feature flags, and display
/// naming stay isolated without a backend.
class AppConfig {
  const AppConfig._({
    required this.flavor,
    required this.appName,
    required this.appNameBn,
    required this.enableDebugLogging,
    required this.enableCrashTools,
    required this.showFlavorBanner,
  });

  final AppFlavor flavor;
  final String appName;
  final String appNameBn;
  final bool enableDebugLogging;
  final bool enableCrashTools;
  final bool showFlavorBanner;

  static late AppConfig current;

  /// Keep in sync with `pubspec.yaml` → `version:` (name before `+`).
  static const String versionName = '0.1.0';

  /// Keep in sync with `pubspec.yaml` → `version:` (number after `+`).
  static const int versionCode = 1;

  static void initialize(AppFlavor flavor) {
    current = switch (flavor) {
      AppFlavor.dev => const AppConfig._(
        flavor: AppFlavor.dev,
        appName: 'Shishur Dinlipi Dev',
        appNameBn: 'শিশুর দিনলিপি Dev',
        enableDebugLogging: true,
        enableCrashTools: true,
        showFlavorBanner: true,
      ),
      AppFlavor.staging => const AppConfig._(
        flavor: AppFlavor.staging,
        appName: 'Shishur Dinlipi Staging',
        appNameBn: 'শিশুর দিনলিপি Staging',
        enableDebugLogging: true,
        enableCrashTools: true,
        showFlavorBanner: true,
      ),
      AppFlavor.prod => const AppConfig._(
        flavor: AppFlavor.prod,
        appName: 'Shishur Dinlipi',
        appNameBn: 'শিশুর দিনলিপি',
        enableDebugLogging: false,
        enableCrashTools: false,
        showFlavorBanner: false,
      ),
    };
  }
}
