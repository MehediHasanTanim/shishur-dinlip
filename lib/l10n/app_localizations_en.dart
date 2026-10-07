// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shishur Dinlipi';

  @override
  String get appNameBn => 'শিশুর দিনলিপি';

  @override
  String get tagline => 'Your child\'s story, preserved with care.';

  @override
  String get navHome => 'Home';

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navAdd => 'Add';

  @override
  String get navAlbums => 'Albums';

  @override
  String get navMore => 'More';

  @override
  String get splashTitle => 'Shishur Dinlipi';

  @override
  String get splashLoading => 'Preparing your journal…';

  @override
  String get onboardingTitle =>
      'Preserve the little moments that become big memories.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get homeTitle => 'Home';

  @override
  String get homePlaceholder => 'Your child\'s story starts here.';

  @override
  String get timelineTitle => 'Timeline';

  @override
  String get timelinePlaceholder => 'Memories and records will appear here.';

  @override
  String get addTitle => 'Quick Add';

  @override
  String get addPlaceholder => 'Choose what you want to record.';

  @override
  String get albumsTitle => 'Albums';

  @override
  String get albumsPlaceholder => 'Year in Review and albums will live here.';

  @override
  String get moreTitle => 'More';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageBangla => 'বাংলা';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonGoBack => 'Go Back';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get errorDatabase => 'Could not access the journal database.';

  @override
  String get errorFile => 'Could not access a file.';

  @override
  String get errorValidation => 'Please check the highlighted fields.';

  @override
  String get errorPermission => 'Permission is required to continue.';

  @override
  String get errorBackup => 'Backup failed.';

  @override
  String get errorRestore => 'Restore failed.';

  @override
  String get errorPdf => 'Could not generate the PDF.';
}
