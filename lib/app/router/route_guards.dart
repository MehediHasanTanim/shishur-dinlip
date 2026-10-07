import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';

/// Pure redirect helper for tests and future app-lock wiring.
String? resolveAppRedirect({
  required AppSettings settings,
  required bool unlocked,
  required GoRouterState state,
}) {
  final location = state.matchedLocation;
  final isSplash = location == AppRoutes.splash;
  final isOnboarding = location == AppRoutes.onboarding;

  if (!unlocked && !isSplash) {
    return AppRoutes.splash;
  }

  if (!settings.onboardingComplete) {
    if (isOnboarding || isSplash) return null;
    return AppRoutes.onboarding;
  }

  if (isSplash || isOnboarding) {
    return AppRoutes.home;
  }

  return null;
}
