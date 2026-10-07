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
  String get chooseLanguageTitle => 'আপনার ভাষা বেছে নিন';

  @override
  String get privacyTitle => 'আপনার শিশুর স্মৃতি আপনার কাছেই থাকে';

  @override
  String get privacyPrivate =>
      'ডিফল্টে ব্যক্তিগত — আপনার ডিভাইসে নিরাপদে সংরক্ষিত।';

  @override
  String get privacyOffline => 'অফলাইনে কাজ করে — ইন্টারনেট লাগে না।';

  @override
  String get privacyControl =>
      'নিয়ন্ত্রণ আপনার — যেকোনো সময় এক্সপোর্ট, ব্যাকআপ বা মুছে ফেলুন।';

  @override
  String get privacyContinue => 'বুঝেছি';

  @override
  String get welcomeTitle => 'ছোট ছোট মুহূর্তগুলোই একদিন বড় স্মৃতি হয়ে থাকে।';

  @override
  String get welcomeCta => 'শিশুর প্রোফাইল তৈরি করুন';

  @override
  String get welcomeHighlightGrowth => 'বৃদ্ধি';

  @override
  String get welcomeHighlightHealth => 'স্বাস্থ্য';

  @override
  String get welcomeHighlightMilestones => 'মাইলফলক';

  @override
  String get welcomeHighlightPhotos => 'ছবি';

  @override
  String get createFirstChildTitle => 'প্রথম শিশু যোগ করুন';

  @override
  String get createFirstChildSubtitle => 'শুরু করতে কিছু মৌলিক তথ্য দিন।';

  @override
  String get addMoreDetailsLater => 'বিস্তারিত পরে যোগ করব';

  @override
  String get securityTitle => 'শিশুর জার্নাল সুরক্ষিত রাখুন';

  @override
  String get securitySubtitle =>
      'ঐচ্ছিক পিন বা বায়োমেট্রিক্স ব্যক্তিগত স্মৃতি রক্ষা করে।';

  @override
  String get securitySetPin => 'পিন সেট করুন';

  @override
  String get securityBiometrics => 'বায়োমেট্রিক্স চালু করুন';

  @override
  String get securityLater => 'পরে সেটআপ করব';

  @override
  String get setupCompleteTitle => 'সব প্রস্তুত!';

  @override
  String setupCompleteSubtitle(String name) {
    return '$name-এর জার্নাল তৈরি। সুন্দর মুহূর্তগুলো ধরে রাখা শুরু করুন।';
  }

  @override
  String get goToHome => 'হোমে যান';

  @override
  String get addFirstMemory => 'প্রথম স্মৃতি যোগ করুন';

  @override
  String get homeTitle => 'হোম';

  @override
  String get homePlaceholder => 'আপনার শিশুর গল্প এখান থেকে শুরু।';

  @override
  String get homeGreetingMorning => 'সুপ্রভাত';

  @override
  String get homeGreetingAfternoon => 'শুভ বিকাল';

  @override
  String get homeGreetingEvening => 'শুভ সন্ধ্যা';

  @override
  String homeAgeLine(String name, String age) {
    return '$name এখন $age';
  }

  @override
  String get growthSnapshot => 'বৃদ্ধির সারাংশ';

  @override
  String get growthEmpty => 'এখনো কোনো মাপ নেই। প্রথম উচ্চতা বা ওজন যোগ করুন।';

  @override
  String get quickAdd => 'দ্রুত যোগ';

  @override
  String get quickAddMemory => 'স্মৃতি';

  @override
  String get quickAddPhoto => 'ছবি';

  @override
  String get quickAddGrowth => 'বৃদ্ধি';

  @override
  String get quickAddMilestone => 'মাইলফলক';

  @override
  String get quickAddHealth => 'স্বাস্থ্য';

  @override
  String get quickAddAchievement => 'অর্জন';

  @override
  String get recentMemories => 'সাম্প্রতিক স্মৃতি';

  @override
  String get recentMemoriesEmpty =>
      'এখনো কোনো স্মৃতি নেই। প্রথম স্মৃতি যোগ করে গল্প শুরু করুন।';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String get upcomingEmpty => 'এখনো কোনো রিমাইন্ডার নেই।';

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
  String get commonDelete => 'মুছুন';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get commonSkip => 'এখন নয়';

  @override
  String get commonSearch => 'খুঁজুন';

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

  @override
  String get childName => 'শিশুর নাম';

  @override
  String get childNickname => 'ডাকনাম';

  @override
  String get childDob => 'জন্ম তারিখ';

  @override
  String get childGender => 'লিঙ্গ';

  @override
  String get childGenderBoy => 'ছেলে';

  @override
  String get childGenderGirl => 'মেয়ে';

  @override
  String get childGenderOther => 'অন্যান্য';

  @override
  String get childBloodGroup => 'রক্তের গ্রুপ';

  @override
  String get childBirthWeight => 'জন্মের ওজন (কেজি)';

  @override
  String get childBirthHeight => 'জন্মের উচ্চতা (সেমি)';

  @override
  String get childBirthplace => 'জন্মস্থান';

  @override
  String get childSchool => 'স্কুল';

  @override
  String get childClass => 'ক্লাস';

  @override
  String get childNotes => 'নোট';

  @override
  String get childNameRequired => 'শিশুর নাম আবশ্যক।';

  @override
  String get childDobFuture => 'জন্ম তারিখ ভবিষ্যতে হতে পারে না।';

  @override
  String get saveChild => 'শিশু সংরক্ষণ';

  @override
  String get addChild => 'শিশু যোগ করুন';

  @override
  String get addAnotherChild => 'আরেকটি শিশু যোগ করুন';

  @override
  String get editChild => 'শিশু সম্পাদনা';

  @override
  String get childProfile => 'শিশুর প্রোফাইল';

  @override
  String get manageChildren => 'শিশু ব্যবস্থাপনা';

  @override
  String get selectChild => 'একজন শিশু বেছে নিন';

  @override
  String get childrenTitle => 'শিশুরা';

  @override
  String get noChildrenTitle => 'এখনো কোনো শিশু নেই';

  @override
  String get noChildrenMessage =>
      'গল্প সংরক্ষণ শুরু করতে একটি শিশুর প্রোফাইল যোগ করুন।';

  @override
  String get aboutSection => 'সম্পর্কে';

  @override
  String get deleteChildTitle => 'এই শিশু মুছবেন?';

  @override
  String deleteChildMessage(String name) {
    return 'এতে $name-এর জার্নাল এ ডিভাইস থেকে সরবে। আগে ব্যাকআপ নেওয়ার পরামর্শ। সহজে ফেরত আনা যাবে না।';
  }

  @override
  String get deleteChildConfirm => 'শিশু মুছুন';

  @override
  String get setAsSelected => 'নির্বাচিত করুন';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get removePhoto => 'ছবি সরান';

  @override
  String get replacePhoto => 'ছবি বদলান';

  @override
  String get addPhotoTitle => 'একটি ছবি যোগ করুন';

  @override
  String get photoPermissionDenied =>
      'ছবি যোগ করতে চাইলেই কেবল ফটো অ্যাক্সেস লাগে।';

  @override
  String get cameraPermissionDenied =>
      'ছবি তুলতে চাইলেই কেবল ক্যামেরা অ্যাক্সেস লাগে।';

  @override
  String get basicSection => 'মৌলিক';

  @override
  String get birthSection => 'জন্ম';

  @override
  String get healthSection => 'স্বাস্থ্য';

  @override
  String get schoolSection => 'স্কুল';

  @override
  String get notesSection => 'নোট';
}
