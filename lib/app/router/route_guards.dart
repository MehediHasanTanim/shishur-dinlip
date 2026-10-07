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
  final isOnboarding = location == AppRoutes.onboarding ||
      location.startsWith('${AppRoutes.onboarding}/');

  final isUnlock = location == AppRoutes.unlock;
  if (!unlocked && !isSplash && !isUnlock && !isOnboarding) {
    return AppRoutes.unlock;
  }
  if (unlocked && isUnlock) {
    return AppRoutes.home;
  }

  if (!settings.onboardingComplete) {
    if (isOnboarding || isSplash) return null;
    return AppRoutes.onboardingLanguage;
  }

  if (isSplash || isOnboarding) {
    return AppRoutes.home;
  }

  return null;
}
