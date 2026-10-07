// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Shishur Dinlipi';

  @override
  String get appNameBn => 'শিশুর দিনলিপি';

  @override
  String get tagline => 'আপনার শিশুর গল্প, যত্নে সংরক্ষিত।';

  @override
  String get navHome => 'হোম';

  @override
  String get navTimeline => 'সময়রেখা';

  @override
  String get navAdd => 'যোগ করুন';

  @override
  String get navAlbums => 'অ্যালবাম';

  @override
  String get navMore => 'আরও';

  @override
  String get splashTitle => 'শিশুর দিনলিপি';

  @override
  String get splashLoading => 'আপনার জার্নাল প্রস্তুত হচ্ছে…';

  @override
  String get onboardingTitle =>
      'ছোট ছোট মুহূর্তগুলোই একদিন বড় স্মৃতি হয়ে থাকে।';

  @override
  String get onboardingContinue => 'এগিয়ে যান';

  @override
  String get homeTitle => 'হোম';

  @override
  String get homePlaceholder => 'আপনার শিশুর গল্প এখান থেকে শুরু।';

  @override
  String get timelineTitle => 'সময়রেখা';

  @override
  String get timelinePlaceholder => 'স্মৃতি ও রেকর্ড এখানে দেখা যাবে।';

  @override
  String get addTitle => 'দ্রুত যোগ';

  @override
  String get addPlaceholder => 'কী যোগ করতে চান তা বেছে নিন।';

  @override
  String get albumsTitle => 'অ্যালবাম';

  @override
  String get albumsPlaceholder => 'বছরের স্মৃতিচারণ ও অ্যালবাম এখানে থাকবে।';

  @override
  String get moreTitle => 'আরও';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsGeneral => 'সাধারণ';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsAppearance => 'চেহারা';

  @override
  String get settingsThemeSystem => 'সিস্টেম';

  @override
  String get settingsThemeLight => 'লাইট';

  @override
  String get settingsThemeDark => 'ডার্ক';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageBangla => 'বাংলা';

  @override
  String get settingsAbout => 'সম্পর্কে';

  @override
  String settingsVersion(String version) {
    return 'সংস্করণ $version';
  }

  @override
  String get commonRetry => 'আবার চেষ্টা';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonContinue => 'এগিয়ে যান';

  @override
  String get commonGoBack => 'ফিরে যান';

  @override
  String get errorGeneric => 'কিছু একটা সমস্যা হয়েছে।';

  @override
  String get errorDatabase => 'জার্নাল ডাটাবেস খোলা যায়নি।';

  @override
  String get errorFile => 'ফাইল অ্যাক্সেস করা যায়নি।';

  @override
  String get errorValidation => 'চিহ্নিত ঘরগুলো যাচাই করুন।';

  @override
  String get errorPermission => 'এগিয়ে যেতে অনুমতি প্রয়োজন।';

  @override
  String get errorBackup => 'ব্যাকআপ ব্যর্থ হয়েছে।';

  @override
  String get errorRestore => 'পুনরুদ্ধার ব্যর্থ হয়েছে।';

  @override
  String get errorPdf => 'পিডিএফ তৈরি করা যায়নি।';
}
