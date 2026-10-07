import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/app/router/route_guards.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';

class _FakeGoRouterState extends Fake implements GoRouterState {
  _FakeGoRouterState(this._location);

  final String _location;

  @override
  String get matchedLocation => _location;
}

void main() {
  test('sends incomplete onboarding users to language step', () {
    final result = resolveAppRedirect(
      settings: const AppSettings(onboardingComplete: false),
      unlocked: true,
      state: _FakeGoRouterState(AppRoutes.home),
    );
    expect(result, AppRoutes.onboardingLanguage);
  });

  test('allows onboarding sub-routes while incomplete', () {
    final result = resolveAppRedirect(
      settings: const AppSettings(onboardingComplete: false),
      unlocked: true,
      state: _FakeGoRouterState(AppRoutes.onboardingPrivacy),
    );
    expect(result, isNull);
  });

  test('locks non-splash routes when unlocked is false', () {
    final result = resolveAppRedirect(
      settings: const AppSettings(onboardingComplete: true),
      unlocked: false,
      state: _FakeGoRouterState(AppRoutes.home),
    );
    expect(result, AppRoutes.splash);
  });

  test('moves completed users off splash to home', () {
    final result = resolveAppRedirect(
      settings: const AppSettings(onboardingComplete: true),
      unlocked: true,
      state: _FakeGoRouterState(AppRoutes.splash),
    );
    expect(result, AppRoutes.home);
  });
}
