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

  static String childDetailPath(String id) => '/children/$id';
  static String childEditPath(String id) => '/children/$id/edit';
}
