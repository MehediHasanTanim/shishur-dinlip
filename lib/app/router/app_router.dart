import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/app/router/route_guards.dart';
import 'package:shishur_dinlipi/app/shell/main_shell.dart';
import 'package:shishur_dinlipi/core/security/app_lock_controller.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/backup/backup_screen.dart';
import 'package:shishur_dinlipi/features/backup/restore_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_compare_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_detail_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_editor_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_interview_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_list_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/favorite_editor_screen.dart';
import 'package:shishur_dinlipi/features/birthdays/favorites_overview_screen.dart';
import 'package:shishur_dinlipi/features/life/family_event_detail_screen.dart';
import 'package:shishur_dinlipi/features/life/family_event_editor_screen.dart';
import 'package:shishur_dinlipi/features/life/family_events_list_screen.dart';
import 'package:shishur_dinlipi/features/life/interest_detail_screen.dart';
import 'package:shishur_dinlipi/features/life/interest_editor_screen.dart';
import 'package:shishur_dinlipi/features/life/interests_list_screen.dart';
import 'package:shishur_dinlipi/features/life/trip_detail_screen.dart';
import 'package:shishur_dinlipi/features/life/trip_editor_screen.dart';
import 'package:shishur_dinlipi/features/life/trips_list_screen.dart';
import 'package:shishur_dinlipi/features/security/security_settings_screen.dart';
import 'package:shishur_dinlipi/features/security/unlock_screen.dart';
import 'package:shishur_dinlipi/features/storage/storage_screen.dart';
import 'package:shishur_dinlipi/features/add/add_screen.dart';
import 'package:shishur_dinlipi/features/albums/album_detail_screen.dart';
import 'package:shishur_dinlipi/features/albums/album_editor_screen.dart';
import 'package:shishur_dinlipi/features/albums/albums_screen.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_editor_screen.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_generate_screen.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_home_screen.dart';
import 'package:shishur_dinlipi/features/children/child_detail_screen.dart';
import 'package:shishur_dinlipi/features/children/child_editor_screen.dart';
import 'package:shishur_dinlipi/features/children/children_list_screen.dart';
import 'package:shishur_dinlipi/features/home/home_screen.dart';
import 'package:shishur_dinlipi/features/photos/photo_detail_screen.dart';
import 'package:shishur_dinlipi/features/photos/photos_screen.dart';
import 'package:shishur_dinlipi/features/search/search_screen.dart';
import 'package:shishur_dinlipi/features/development/first_word_detail_screen.dart';
import 'package:shishur_dinlipi/features/development/first_word_editor_screen.dart';
import 'package:shishur_dinlipi/features/development/first_words_list_screen.dart';
import 'package:shishur_dinlipi/features/development/growth_detail_screen.dart';
import 'package:shishur_dinlipi/features/development/growth_editor_screen.dart';
import 'package:shishur_dinlipi/features/development/growth_history_screen.dart';
import 'package:shishur_dinlipi/features/development/growth_overview_screen.dart';
import 'package:shishur_dinlipi/features/development/milestone_detail_screen.dart';
import 'package:shishur_dinlipi/features/development/milestone_editor_screen.dart';
import 'package:shishur_dinlipi/features/development/milestone_list_screen.dart';
import 'package:shishur_dinlipi/features/development/milestone_templates.dart';
import 'package:shishur_dinlipi/features/development/milestones_overview_screen.dart';
import 'package:shishur_dinlipi/features/health/doctor_visit_detail_screen.dart';
import 'package:shishur_dinlipi/features/health/doctor_visit_editor_screen.dart';
import 'package:shishur_dinlipi/features/health/doctor_visit_list_screen.dart';
import 'package:shishur_dinlipi/features/health/health_overview_screen.dart';
import 'package:shishur_dinlipi/features/health/illness_detail_screen.dart';
import 'package:shishur_dinlipi/features/health/illness_editor_screen.dart';
import 'package:shishur_dinlipi/features/health/illness_list_screen.dart';
import 'package:shishur_dinlipi/features/health/medical_document_detail_screen.dart';
import 'package:shishur_dinlipi/features/health/medical_document_editor_screen.dart';
import 'package:shishur_dinlipi/features/health/medical_document_list_screen.dart';
import 'package:shishur_dinlipi/features/health/medicine_detail_screen.dart';
import 'package:shishur_dinlipi/features/health/medicine_editor_screen.dart';
import 'package:shishur_dinlipi/features/health/medicine_list_screen.dart';
import 'package:shishur_dinlipi/features/health/vaccination_detail_screen.dart';
import 'package:shishur_dinlipi/features/health/vaccination_editor_screen.dart';
import 'package:shishur_dinlipi/features/health/vaccination_list_screen.dart';
import 'package:shishur_dinlipi/features/school/school_event_detail_screen.dart';
import 'package:shishur_dinlipi/features/school/school_event_editor_screen.dart';
import 'package:shishur_dinlipi/features/school/school_overview_screen.dart';
import 'package:shishur_dinlipi/features/school/school_profile_detail_screen.dart';
import 'package:shishur_dinlipi/features/school/school_profile_editor_screen.dart';
import 'package:shishur_dinlipi/features/school/school_timeline_screen.dart';
import 'package:shishur_dinlipi/features/memories/achievement_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/achievement_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/funny_moment_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/funny_moment_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_detail_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_editor_screen.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/features/calendar/calendar_screen.dart';
import 'package:shishur_dinlipi/features/more/more_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_complete_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_create_child_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_language_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_privacy_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_security_screen.dart';
import 'package:shishur_dinlipi/features/onboarding/onboarding_welcome_screen.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_detail_screen.dart';
import 'package:shishur_dinlipi/features/reminders/reminder_editor_screen.dart';
import 'package:shishur_dinlipi/features/reminders/reminders_list_screen.dart';
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
        path: AppRoutes.unlock,
        builder: (context, state) => const UnlockScreen(),
      ),
      GoRoute(
        path: AppRoutes.security,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.backup,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: AppRoutes.restore,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RestoreScreen(),
      ),
      GoRoute(
        path: AppRoutes.storage,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StorageScreen(),
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
      GoRoute(
        path: AppRoutes.growth,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GrowthOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.growthHistory,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GrowthHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.growthCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GrowthEditorScreen(),
      ),
      GoRoute(
        path: '/growth/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => GrowthDetailScreen(
          recordId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => GrowthEditorScreen(
              recordId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.milestones,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MilestonesOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.milestoneCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final raw = state.uri.queryParameters['template'];
          MilestoneTemplate? template;
          if (raw != null) {
            for (final value in MilestoneTemplate.values) {
              if (value.name == raw) {
                template = value;
                break;
              }
            }
          }
          return MilestoneEditorScreen(
            template: template,
            initialCategory: state.uri.queryParameters['category'],
          );
        },
      ),
      GoRoute(
        path: '/milestones/category/:category',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MilestoneListScreen(
          category: state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: '/milestones/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MilestoneDetailScreen(
          milestoneId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => MilestoneEditorScreen(
              milestoneId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.firstWords,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FirstWordsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.firstWordCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FirstWordEditorScreen(),
      ),
      GoRoute(
        path: '/first-words/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => FirstWordDetailScreen(
          wordId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => FirstWordEditorScreen(
              wordId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.school,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SchoolOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.schoolTimeline,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SchoolTimelineScreen(),
      ),
      GoRoute(
        path: AppRoutes.schoolProfileCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SchoolProfileEditorScreen(),
      ),
      GoRoute(
        path: '/school/profiles/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SchoolProfileDetailScreen(
          profileId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => SchoolProfileEditorScreen(
              profileId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.schoolEventCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SchoolEventEditorScreen(
          initialSchoolProfileId:
              state.uri.queryParameters['schoolProfileId'],
          initialEventType: state.uri.queryParameters['eventType'],
        ),
      ),
      GoRoute(
        path: '/school/events/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => SchoolEventDetailScreen(
          eventId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => SchoolEventEditorScreen(
              eventId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.health,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HealthOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.vaccinations,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VaccinationListScreen(),
      ),
      GoRoute(
        path: AppRoutes.vaccinationCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VaccinationEditorScreen(),
      ),
      GoRoute(
        path: '/health/vaccinations/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => VaccinationDetailScreen(
          vaccinationId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => VaccinationEditorScreen(
              vaccinationId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.illnesses,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const IllnessListScreen(),
      ),
      GoRoute(
        path: AppRoutes.illnessCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const IllnessEditorScreen(),
      ),
      GoRoute(
        path: '/health/illnesses/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => IllnessDetailScreen(
          illnessId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => IllnessEditorScreen(
              illnessId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.medicines,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MedicineListScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicineCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MedicineEditorScreen(),
      ),
      GoRoute(
        path: '/health/medicines/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MedicineDetailScreen(
          medicineId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => MedicineEditorScreen(
              medicineId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.doctorVisits,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DoctorVisitListScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorVisitCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DoctorVisitEditorScreen(),
      ),
      GoRoute(
        path: '/health/doctor-visits/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => DoctorVisitDetailScreen(
          visitId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => DoctorVisitEditorScreen(
              visitId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.medicalDocuments,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MedicalDocumentListScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalDocumentCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MedicalDocumentEditorScreen(),
      ),
      GoRoute(
        path: '/health/documents/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MedicalDocumentDetailScreen(
          documentId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => MedicalDocumentEditorScreen(
              documentId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.calendar,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.photos,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PhotosScreen(),
      ),
      GoRoute(
        path: '/photos/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PhotoDetailScreen(
          photoId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.albumCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AlbumEditorScreen(),
      ),
      GoRoute(
        path: '/albums/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => AlbumDetailScreen(
          albumId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => AlbumEditorScreen(
              albumId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.birthdays,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BirthdaysListScreen(),
      ),
      GoRoute(
        path: AppRoutes.birthdayCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BirthdayEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.birthdayCompare,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BirthdayCompareScreen(),
      ),
      GoRoute(
        path: '/birthdays/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BirthdayDetailScreen(
          birthdayId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => BirthdayEditorScreen(
              birthdayId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: 'interview',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => BirthdayInterviewScreen(
              birthdayId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.favorites,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FavoritesOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.favoriteCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FavoriteEditorScreen(),
      ),
      GoRoute(
        path: '/favorites/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => FavoriteEditorScreen(
          favoriteId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: AppRoutes.interests,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InterestsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.interestCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InterestEditorScreen(),
      ),
      GoRoute(
        path: '/interests/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => InterestDetailScreen(
          interestId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => InterestEditorScreen(
              interestId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.familyEvents,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FamilyEventsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.familyEventCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => FamilyEventEditorScreen(
          initialType: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: '/family-events/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => FamilyEventDetailScreen(
          eventId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => FamilyEventEditorScreen(
              eventId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.trips,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TripsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TripEditorScreen(
          initialType: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: '/trips/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TripDetailScreen(
          tripId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => TripEditorScreen(
              tripId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.yearReview,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const YearReviewHomeScreen(),
      ),
      GoRoute(
        path: '/year-review/:year',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final year = int.tryParse(state.pathParameters['year'] ?? '') ??
              DateTime.now().year;
          return YearReviewEditorScreen(year: year);
        },
        routes: [
          GoRoute(
            path: 'generate',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) {
              final year =
                  int.tryParse(state.pathParameters['year'] ?? '') ??
                  DateTime.now().year;
              return YearReviewGenerateScreen(year: year);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.reminders,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RemindersListScreen(),
      ),
      GoRoute(
        path: AppRoutes.reminderCreate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReminderEditorScreen(),
      ),
      GoRoute(
        path: '/reminders/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReminderDetailScreen(
          reminderId: state.pathParameters['id']!,
        ),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => ReminderEditorScreen(
              reminderId: state.pathParameters['id'],
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
