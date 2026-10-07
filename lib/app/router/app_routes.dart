abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const onboardingLanguage = '/onboarding/language';
  static const onboardingPrivacy = '/onboarding/privacy';
  static const onboardingWelcome = '/onboarding/welcome';
  static const onboardingCreateChild = '/onboarding/create-child';
  static const onboardingSecurity = '/onboarding/security';
  static const onboardingComplete = '/onboarding/complete';
  static const home = '/home';
  static const timeline = '/timeline';
  static const add = '/add';
  static const albums = '/albums';
  static const more = '/more';
  static const settings = '/settings';
  static const children = '/children';
  static const childCreate = '/children/create';
  static const childEdit = '/children/:id/edit';
  static const childDetail = '/children/:id';

  static const journalCreate = '/journal/create';
  static const funnyCreate = '/funny/create';
  static const achievementCreate = '/achievements/create';

  static String childDetailPath(String id) => '/children/$id';
  static String childEditPath(String id) => '/children/$id/edit';

  static String journalCreatePath({String? template}) {
    if (template == null || template.isEmpty) return journalCreate;
    return '$journalCreate?template=$template';
  }

  static String journalDetailPath(String id) => '/journal/$id';
  static String journalEditPath(String id) => '/journal/$id/edit';
  static String funnyDetailPath(String id) => '/funny/$id';
  static String funnyEditPath(String id) => '/funny/$id/edit';
  static String achievementDetailPath(String id) => '/achievements/$id';
  static String achievementEditPath(String id) => '/achievements/$id/edit';
}
