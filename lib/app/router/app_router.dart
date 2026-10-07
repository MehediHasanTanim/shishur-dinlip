import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/app/router/route_guards.dart';
import 'package:shishur_dinlipi/app/shell/main_shell.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/add/add_screen.dart';
import 'package:shishur_dinlipi/features/albums/albums_screen.dart';
import 'package:shishur_dinlipi/features/children/child_detail_screen.dart';
import 'package:shishur_dinlipi/features/children/child_editor_screen.dart';
import 'package:shishur_dinlipi/features/children/children_list_screen.dart';
import 'package:shishur_dinlipi/features/home/home_screen.dart';
import 'package:shishur_dinlipi/features/memories/achievement_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/achievement_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/funny_moment_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/funny_moment_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/features/more/more_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_complete_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_create_child_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_language_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_privacy_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_security_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_welcome_screen.dart';
import 'package:shishur_dinlipi/features/settings/settings_screen.dart';
import 'package:shishur_dinlipi/features/splash/splash_screen.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(settingsControllerProvider, (_, _) => refresh.value++);
  ref.listen(appUnlockedProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final settings =
          ref.read(settingsControllerProvider).valueOrNull ??
          const AppSettings();
      return resolveAppRedirect(
        settings: settings,
        unlocked: ref.read(appUnlockedProvider),
        state: state,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingLanguage,
        builder: (context, state) => const OnboardingLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPrivacy,
        builder: (context, state) => const OnboardingPrivacyScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingWelcome,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCreateChild,
        builder: (context, state) => const OnboardingCreateChildScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingSecurity,
        builder: (context, state) => const OnboardingSecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingComplete,
        builder: (context, state) => const OnboardingCompleteScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.children,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChildrenListScreen(),
      ),
      GoRoute(
        path: AppRoutes.childCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChildEditorScreen(),
      ),
      GoRoute(
        path: '/children/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ChildDetailScreen(
          childId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => ChildEditorScreen(
              childId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.journalCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final raw = state.uri.queryParameters['template'];
          JournalTemplate? template;
          if (raw != null) {
            for (final value in JournalTemplate.values) {
              if (value.name == raw) {
                template = value;
                break;
              }
            }
          }
          return JournalEditorScreen(template: template);
        },
      ),
      GoRoute(
        path: '/journal/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => JournalDetailScreen(
          entryId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => JournalEditorScreen(
              entryId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.funnyCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FunnyMomentEditorScreen(),
      ),
      GoRoute(
        path: '/funny/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => FunnyMomentDetailScreen(
          momentId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => FunnyMomentEditorScreen(
              momentId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.achievementCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AchievementEditorScreen(),
      ),
      GoRoute(
        path: '/achievements/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => AchievementDetailScreen(
          achievementId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => AchievementEditorScreen(
              achievementId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.timeline,
                builder: (context, state) => const TimelineScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.add,
                builder: (context, state) => const AddScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.albums,
                builder: (context, state) => const AlbumsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.more,
                builder: (context, state) => const MoreScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
