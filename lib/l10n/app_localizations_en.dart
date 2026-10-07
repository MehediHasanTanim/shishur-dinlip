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
  String get chooseLanguageTitle => 'Choose your language';

  @override
  String get privacyTitle => 'Your child\'s memories stay with you';

  @override
  String get privacyPrivate =>
      'Private by default — stored securely on your device.';

  @override
  String get privacyOffline => 'Works offline — no internet required.';

  @override
  String get privacyControl =>
      'You are in control — export, backup, or delete anytime.';

  @override
  String get privacyContinue => 'I understand';

  @override
  String get welcomeTitle =>
      'Preserve the little moments that become big memories.';

  @override
  String get welcomeCta => 'Create child profile';

  @override
  String get welcomeHighlightGrowth => 'Growth';

  @override
  String get welcomeHighlightHealth => 'Health';

  @override
  String get welcomeHighlightMilestones => 'Milestones';

  @override
  String get welcomeHighlightPhotos => 'Photos';

  @override
  String get createFirstChildTitle => 'Create your first child';

  @override
  String get createFirstChildSubtitle =>
      'Add some basic information to get started.';

  @override
  String get addMoreDetailsLater => 'Add more details later';

  @override
  String get securityTitle => 'Protect your child\'s journal';

  @override
  String get securitySubtitle =>
      'Optional PIN or biometrics keep private memories private.';

  @override
  String get securitySetPin => 'Set PIN';

  @override
  String get securityBiometrics => 'Enable biometrics';

  @override
  String get securityLater => 'Set up later';

  @override
  String get setupCompleteTitle => 'You\'re all set!';

  @override
  String setupCompleteSubtitle(String name) {
    return '$name\'s journal is ready. Start capturing beautiful moments.';
  }

  @override
  String get goToHome => 'Go to Home';

  @override
  String get addFirstMemory => 'Add first memory';

  @override
  String get homeTitle => 'Home';

  @override
  String get homePlaceholder => 'Your child\'s story starts here.';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String homeAgeLine(String name, String age) {
    return '$name is now $age';
  }

  @override
  String get growthSnapshot => 'Growth snapshot';

  @override
  String get growthEmpty =>
      'No measurements yet. Add the first height or weight.';

  @override
  String get quickAdd => 'Quick add';

  @override
  String get quickAddMemory => 'Memory';

  @override
  String get quickAddPhoto => 'Photo';

  @override
  String get quickAddGrowth => 'Growth';

  @override
  String get quickAddMilestone => 'Milestone';

  @override
  String get quickAddHealth => 'Health';

  @override
  String get quickAddAchievement => 'Achievement';

  @override
  String get recentMemories => 'Recent memories';

  @override
  String get recentMemoriesEmpty =>
      'No memories yet. Add your first memory and begin the story.';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get upcomingEmpty => 'No reminders yet.';

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
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonSkip => 'Skip for now';

  @override
  String get commonSearch => 'Search';

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

  @override
  String get childName => 'Child\'s name';

  @override
  String get childNickname => 'Nickname';

  @override
  String get childDob => 'Date of birth';

  @override
  String get childGender => 'Gender';

  @override
  String get childGenderBoy => 'Boy';

  @override
  String get childGenderGirl => 'Girl';

  @override
  String get childGenderOther => 'Other';

  @override
  String get childBloodGroup => 'Blood group';

  @override
  String get childBirthWeight => 'Birth weight (kg)';

  @override
  String get childBirthHeight => 'Birth height (cm)';

  @override
  String get childBirthplace => 'Birthplace';

  @override
  String get childSchool => 'School';

  @override
  String get childClass => 'Class';

  @override
  String get childNotes => 'Notes';

  @override
  String get childNameRequired => 'Child name is required.';

  @override
  String get childDobFuture => 'Date of birth cannot be in the future.';

  @override
  String get saveChild => 'Save child';

  @override
  String get addChild => 'Add child';

  @override
  String get addAnotherChild => 'Add another child';

  @override
  String get editChild => 'Edit child';

  @override
  String get childProfile => 'Child profile';

  @override
  String get manageChildren => 'Manage children';

  @override
  String get selectChild => 'Select a child';

  @override
  String get childrenTitle => 'Children';

  @override
  String get noChildrenTitle => 'No children yet';

  @override
  String get noChildrenMessage =>
      'Add a child profile to start preserving their story.';

  @override
  String get aboutSection => 'About';

  @override
  String get deleteChildTitle => 'Delete this child?';

  @override
  String deleteChildMessage(String name) {
    return 'This removes $name\'s journal entries from this device. Consider creating a backup first. This cannot be undone easily.';
  }

  @override
  String get deleteChildConfirm => 'Delete child';

  @override
  String get setAsSelected => 'Set as selected';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get replacePhoto => 'Replace photo';

  @override
  String get addPhotoTitle => 'Add a photo';

  @override
  String get photoPermissionDenied =>
      'Photo access is needed only when you choose to add a picture.';

  @override
  String get cameraPermissionDenied =>
      'Camera access is needed only when you choose to take a photo.';

  @override
  String get basicSection => 'Basic';

  @override
  String get birthSection => 'Birth';

  @override
  String get healthSection => 'Health';

  @override
  String get schoolSection => 'School';

  @override
  String get notesSection => 'Notes';
}
