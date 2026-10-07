import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Shishur Dinlipi'**
  String get appName;

  /// No description provided for @appNameBn.
  ///
  /// In en, this message translates to:
  /// **'শিশুর দিনলিপি'**
  String get appNameBn;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s story, preserved with care.'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navTimeline;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get navAlbums;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Shishur Dinlipi'**
  String get splashTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing your journal…'**
  String get splashLoading;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve the little moments that become big memories.'**
  String get onboardingTitle;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s memories stay with you'**
  String get privacyTitle;

  /// No description provided for @privacyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private by default — stored securely on your device.'**
  String get privacyPrivate;

  /// No description provided for @privacyOffline.
  ///
  /// In en, this message translates to:
  /// **'Works offline — no internet required.'**
  String get privacyOffline;

  /// No description provided for @privacyControl.
  ///
  /// In en, this message translates to:
  /// **'You are in control — export, backup, or delete anytime.'**
  String get privacyControl;

  /// No description provided for @privacyContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get privacyContinue;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve the little moments that become big memories.'**
  String get welcomeTitle;

  /// No description provided for @welcomeCta.
  ///
  /// In en, this message translates to:
  /// **'Create child profile'**
  String get welcomeCta;

  /// No description provided for @welcomeHighlightGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get welcomeHighlightGrowth;

  /// No description provided for @welcomeHighlightHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get welcomeHighlightHealth;

  /// No description provided for @welcomeHighlightMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get welcomeHighlightMilestones;

  /// No description provided for @welcomeHighlightPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get welcomeHighlightPhotos;

  /// No description provided for @createFirstChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first child'**
  String get createFirstChildTitle;

  /// No description provided for @createFirstChildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some basic information to get started.'**
  String get createFirstChildSubtitle;

  /// No description provided for @addMoreDetailsLater.
  ///
  /// In en, this message translates to:
  /// **'Add more details later'**
  String get addMoreDetailsLater;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your child\'s journal'**
  String get securityTitle;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional PIN or biometrics keep private memories private.'**
  String get securitySubtitle;

  /// No description provided for @securitySetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get securitySetPin;

  /// No description provided for @securityBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enable biometrics'**
  String get securityBiometrics;

  /// No description provided for @securityLater.
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get securityLater;

  /// No description provided for @setupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get setupCompleteTitle;

  /// No description provided for @setupCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s journal is ready. Start capturing beautiful moments.'**
  String setupCompleteSubtitle(String name);

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @addFirstMemory.
  ///
  /// In en, this message translates to:
  /// **'Add first memory'**
  String get addFirstMemory;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s story starts here.'**
  String get homePlaceholder;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeAgeLine.
  ///
  /// In en, this message translates to:
  /// **'{name} is now {age}'**
  String homeAgeLine(String name, String age);

  /// No description provided for @growthSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Growth snapshot'**
  String get growthSnapshot;

  /// No description provided for @growthEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet. Add the first height or weight.'**
  String get growthEmpty;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAdd;

  /// No description provided for @quickAddMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get quickAddMemory;

  /// No description provided for @quickAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get quickAddPhoto;

  /// No description provided for @quickAddGrowth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get quickAddGrowth;

  /// No description provided for @quickAddMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get quickAddMilestone;

  /// No description provided for @quickAddHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get quickAddHealth;

  /// No description provided for @quickAddAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get quickAddAchievement;

  /// No description provided for @recentMemories.
  ///
  /// In en, this message translates to:
  /// **'Recent memories'**
  String get recentMemories;

  /// No description provided for @recentMemoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No memories yet. Add your first memory and begin the story.'**
  String get recentMemoriesEmpty;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @upcomingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get upcomingEmpty;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineTitle;

  /// No description provided for @timelinePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Memories and records will appear here.'**
  String get timelinePlaceholder;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get addTitle;

  /// No description provided for @addPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to record.'**
  String get addPlaceholder;

  /// No description provided for @albumsTitle.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumsTitle;

  /// No description provided for @albumsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Year in Review and albums will live here.'**
  String get albumsPlaceholder;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get settingsLanguageBangla;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get commonGoBack;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get commonSkip;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Could not access the journal database.'**
  String get errorDatabase;

  /// No description provided for @errorFile.
  ///
  /// In en, this message translates to:
  /// **'Could not access a file.'**
  String get errorFile;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get errorValidation;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission is required to continue.'**
  String get errorPermission;

  /// No description provided for @errorBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup failed.'**
  String get errorBackup;

  /// No description provided for @errorRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore failed.'**
  String get errorRestore;

  /// No description provided for @errorPdf.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the PDF.'**
  String get errorPdf;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s name'**
  String get childName;

  /// No description provided for @childNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get childNickname;

  /// No description provided for @childDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get childDob;

  /// No description provided for @childGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get childGender;

  /// No description provided for @childGenderBoy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get childGenderBoy;

  /// No description provided for @childGenderGirl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get childGenderGirl;

  /// No description provided for @childGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get childGenderOther;

  /// No description provided for @childBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get childBloodGroup;

  /// No description provided for @childBirthWeight.
  ///
  /// In en, this message translates to:
  /// **'Birth weight (kg)'**
  String get childBirthWeight;

  /// No description provided for @childBirthHeight.
  ///
  /// In en, this message translates to:
  /// **'Birth height (cm)'**
  String get childBirthHeight;

  /// No description provided for @childBirthplace.
  ///
  /// In en, this message translates to:
  /// **'Birthplace'**
  String get childBirthplace;

  /// No description provided for @childSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get childSchool;

  /// No description provided for @childClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get childClass;

  /// No description provided for @childNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get childNotes;

  /// No description provided for @childNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Child name is required.'**
  String get childNameRequired;

  /// No description provided for @childDobFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get childDobFuture;

  /// No description provided for @saveChild.
  ///
  /// In en, this message translates to:
  /// **'Save child'**
  String get saveChild;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get addChild;

  /// No description provided for @addAnotherChild.
  ///
  /// In en, this message translates to:
  /// **'Add another child'**
  String get addAnotherChild;

  /// No description provided for @editChild.
  ///
  /// In en, this message translates to:
  /// **'Edit child'**
  String get editChild;

  /// No description provided for @childProfile.
  ///
  /// In en, this message translates to:
  /// **'Child profile'**
  String get childProfile;

  /// No description provided for @manageChildren.
  ///
  /// In en, this message translates to:
  /// **'Manage children'**
  String get manageChildren;

  /// No description provided for @selectChild.
  ///
  /// In en, this message translates to:
  /// **'Select a child'**
  String get selectChild;

  /// No description provided for @childrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childrenTitle;

  /// No description provided for @noChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'No children yet'**
  String get noChildrenTitle;

  /// No description provided for @noChildrenMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a child profile to start preserving their story.'**
  String get noChildrenMessage;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @deleteChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this child?'**
  String get deleteChildTitle;

  /// No description provided for @deleteChildMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes {name}\'s journal entries from this device. Consider creating a backup first. This cannot be undone easily.'**
  String deleteChildMessage(String name);

  /// No description provided for @deleteChildConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete child'**
  String get deleteChildConfirm;

  /// No description provided for @setAsSelected.
  ///
  /// In en, this message translates to:
  /// **'Set as selected'**
  String get setAsSelected;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get replacePhoto;

  /// No description provided for @addPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhotoTitle;

  /// No description provided for @photoPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access is needed only when you choose to add a picture.'**
  String get photoPermissionDenied;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera access is needed only when you choose to take a photo.'**
  String get cameraPermissionDenied;

  /// No description provided for @basicSection.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basicSection;

  /// No description provided for @birthSection.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get birthSection;

  /// No description provided for @healthSection.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthSection;

  /// No description provided for @schoolSection.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolSection;

  /// No description provided for @notesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesSection;

  /// No description provided for @addSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to preserve today.'**
  String get addSubtitle;

  /// No description provided for @addGroupMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get addGroupMemories;

  /// No description provided for @addGroupComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get addGroupComingSoon;

  /// No description provided for @addComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'School and health records arrive in later sprints.'**
  String get addComingSoonMessage;

  /// No description provided for @addComingSoonHealthOnly.
  ///
  /// In en, this message translates to:
  /// **'Health records arrive in later sprints.'**
  String get addComingSoonHealthOnly;

  /// No description provided for @addGroupSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get addGroupSchool;

  /// No description provided for @addSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Add school'**
  String get addSchoolProfile;

  /// No description provided for @editSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit school'**
  String get editSchoolProfile;

  /// No description provided for @addSchoolProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'School name, class, and teacher.'**
  String get addSchoolProfileSubtitle;

  /// No description provided for @addSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Add school event'**
  String get addSchoolEvent;

  /// No description provided for @editSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit school event'**
  String get editSchoolEvent;

  /// No description provided for @addSchoolEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First day, exams, certificates, and more.'**
  String get addSchoolEventSubtitle;

  /// No description provided for @addReportCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attach a report card photo or PDF.'**
  String get addReportCardSubtitle;

  /// No description provided for @addGroupDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get addGroupDevelopment;

  /// No description provided for @schoolTitle.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolTitle;

  /// No description provided for @schoolCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current school'**
  String get schoolCurrent;

  /// No description provided for @schoolCurrentBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get schoolCurrentBadge;

  /// No description provided for @schoolEmpty.
  ///
  /// In en, this message translates to:
  /// **'No school profile yet. Add the first one.'**
  String get schoolEmpty;

  /// No description provided for @schoolHistory.
  ///
  /// In en, this message translates to:
  /// **'School history'**
  String get schoolHistory;

  /// No description provided for @schoolEvents.
  ///
  /// In en, this message translates to:
  /// **'School events'**
  String get schoolEvents;

  /// No description provided for @schoolEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No school events yet.'**
  String get schoolEventsEmpty;

  /// No description provided for @schoolRecentEvent.
  ///
  /// In en, this message translates to:
  /// **'Recent school event'**
  String get schoolRecentEvent;

  /// No description provided for @schoolTimeline.
  ///
  /// In en, this message translates to:
  /// **'School timeline'**
  String get schoolTimeline;

  /// No description provided for @schoolAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get schoolAdd;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School name'**
  String get schoolName;

  /// No description provided for @schoolNameRequired.
  ///
  /// In en, this message translates to:
  /// **'School name is required.'**
  String get schoolNameRequired;

  /// No description provided for @schoolClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get schoolClass;

  /// No description provided for @schoolTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get schoolTeacher;

  /// No description provided for @schoolStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get schoolStartDate;

  /// No description provided for @schoolEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get schoolEndDate;

  /// No description provided for @schoolEndDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Still attending (no end date)'**
  String get schoolEndDateOptional;

  /// No description provided for @schoolClearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get schoolClearEndDate;

  /// No description provided for @saveSchoolProfile.
  ///
  /// In en, this message translates to:
  /// **'Save school'**
  String get saveSchoolProfile;

  /// No description provided for @deleteSchoolTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this school?'**
  String get deleteSchoolTitle;

  /// No description provided for @deleteSchoolMessage.
  ///
  /// In en, this message translates to:
  /// **'This school profile will be removed from this device.'**
  String get deleteSchoolMessage;

  /// No description provided for @schoolEventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get schoolEventType;

  /// No description provided for @schoolEventFirstDay.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get schoolEventFirstDay;

  /// No description provided for @schoolEventExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get schoolEventExam;

  /// No description provided for @schoolEventPerformance.
  ///
  /// In en, this message translates to:
  /// **'School performance'**
  String get schoolEventPerformance;

  /// No description provided for @schoolEventSports.
  ///
  /// In en, this message translates to:
  /// **'Sports event'**
  String get schoolEventSports;

  /// No description provided for @schoolEventCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get schoolEventCertificate;

  /// No description provided for @schoolEventPromotion.
  ///
  /// In en, this message translates to:
  /// **'Class promotion'**
  String get schoolEventPromotion;

  /// No description provided for @schoolEventProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get schoolEventProject;

  /// No description provided for @schoolEventReportCard.
  ///
  /// In en, this message translates to:
  /// **'Report card'**
  String get schoolEventReportCard;

  /// No description provided for @schoolEventCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get schoolEventCustom;

  /// No description provided for @schoolEventTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Event title is required.'**
  String get schoolEventTitleRequired;

  /// No description provided for @schoolLinkedProfile.
  ///
  /// In en, this message translates to:
  /// **'Linked school'**
  String get schoolLinkedProfile;

  /// No description provided for @schoolNoLinkedProfile.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get schoolNoLinkedProfile;

  /// No description provided for @schoolAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach photos, certificates, or PDF report cards.'**
  String get schoolAttachmentsHint;

  /// No description provided for @saveSchoolEvent.
  ///
  /// In en, this message translates to:
  /// **'Save school event'**
  String get saveSchoolEvent;

  /// No description provided for @deleteSchoolEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this school event?'**
  String get deleteSchoolEventTitle;

  /// No description provided for @deleteSchoolEventMessage.
  ///
  /// In en, this message translates to:
  /// **'This school event will be removed from this device.'**
  String get deleteSchoolEventMessage;

  /// No description provided for @attachmentsAndDocsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos & documents'**
  String get attachmentsAndDocsTitle;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get addDocument;

  /// No description provided for @schoolDashboard.
  ///
  /// In en, this message translates to:
  /// **'School & achievements'**
  String get schoolDashboard;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @addGrowth.
  ///
  /// In en, this message translates to:
  /// **'Add growth'**
  String get addGrowth;

  /// No description provided for @editGrowth.
  ///
  /// In en, this message translates to:
  /// **'Edit growth'**
  String get editGrowth;

  /// No description provided for @addGrowthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record height and weight.'**
  String get addGrowthSubtitle;

  /// No description provided for @addMilestone.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get addMilestone;

  /// No description provided for @editMilestone.
  ///
  /// In en, this message translates to:
  /// **'Edit milestone'**
  String get editMilestone;

  /// No description provided for @addMilestoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First steps, words, and more.'**
  String get addMilestoneSubtitle;

  /// No description provided for @addFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Add first word'**
  String get addFirstWord;

  /// No description provided for @editFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Edit first word'**
  String get editFirstWord;

  /// No description provided for @addFirstWordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture the first spoken word.'**
  String get addFirstWordSubtitle;

  /// No description provided for @growthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthTitle;

  /// No description provided for @growthHistory.
  ///
  /// In en, this message translates to:
  /// **'Growth history'**
  String get growthHistory;

  /// No description provided for @growthDetail.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get growthDetail;

  /// No description provided for @growthHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get growthHeight;

  /// No description provided for @growthWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get growthWeight;

  /// No description provided for @growthHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get growthHeightCm;

  /// No description provided for @growthHeightFt.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get growthHeightFt;

  /// No description provided for @growthHeightIn.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get growthHeightIn;

  /// No description provided for @growthWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get growthWeightKg;

  /// No description provided for @growthWeightLb.
  ///
  /// In en, this message translates to:
  /// **'Weight (lb)'**
  String get growthWeightLb;

  /// No description provided for @growthNeedValue.
  ///
  /// In en, this message translates to:
  /// **'Enter height, weight, or both.'**
  String get growthNeedValue;

  /// No description provided for @growthPreviousContext.
  ///
  /// In en, this message translates to:
  /// **'Previous: {height} · {weight}'**
  String growthPreviousContext(String height, String weight);

  /// No description provided for @saveGrowth.
  ///
  /// In en, this message translates to:
  /// **'Save measurement'**
  String get saveGrowth;

  /// No description provided for @growthHeightChart.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get growthHeightChart;

  /// No description provided for @growthWeightChart.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get growthWeightChart;

  /// No description provided for @growthRange6m.
  ///
  /// In en, this message translates to:
  /// **'6 mo'**
  String get growthRange6m;

  /// No description provided for @growthRange1y.
  ///
  /// In en, this message translates to:
  /// **'1 yr'**
  String get growthRange1y;

  /// No description provided for @growthRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get growthRangeAll;

  /// No description provided for @growthChartNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Add at least two measurements to see a chart.'**
  String get growthChartNeedMore;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'Height in cm'**
  String get unitCm;

  /// No description provided for @unitFtIn.
  ///
  /// In en, this message translates to:
  /// **'Height in ft/in'**
  String get unitFtIn;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Weight in kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'Weight in lb'**
  String get unitLb;

  /// No description provided for @deleteGrowthTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this measurement?'**
  String get deleteGrowthTitle;

  /// No description provided for @deleteGrowthMessage.
  ///
  /// In en, this message translates to:
  /// **'This growth record will be removed from this device.'**
  String get deleteGrowthMessage;

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestonesTitle;

  /// No description provided for @milestoneCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get milestoneCategories;

  /// No description provided for @milestoneTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick milestones'**
  String get milestoneTemplates;

  /// No description provided for @recentMilestones.
  ///
  /// In en, this message translates to:
  /// **'Recent milestones'**
  String get recentMilestones;

  /// No description provided for @milestonesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No milestones yet. Celebrate a first!'**
  String get milestonesEmpty;

  /// No description provided for @milestoneTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get milestoneTitleField;

  /// No description provided for @milestoneTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Milestone title is required.'**
  String get milestoneTitleRequired;

  /// No description provided for @saveMilestone.
  ///
  /// In en, this message translates to:
  /// **'Save milestone'**
  String get saveMilestone;

  /// No description provided for @milestoneMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get milestoneMovement;

  /// No description provided for @milestoneSpeech.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get milestoneSpeech;

  /// No description provided for @milestoneSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get milestoneSocial;

  /// No description provided for @milestoneSelfCare.
  ///
  /// In en, this message translates to:
  /// **'Self-care'**
  String get milestoneSelfCare;

  /// No description provided for @milestoneLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get milestoneLearning;

  /// No description provided for @milestoneCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get milestoneCustom;

  /// No description provided for @templateFirstCrawl.
  ///
  /// In en, this message translates to:
  /// **'First crawl'**
  String get templateFirstCrawl;

  /// No description provided for @templateFirstStand.
  ///
  /// In en, this message translates to:
  /// **'First stand'**
  String get templateFirstStand;

  /// No description provided for @templateFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First step'**
  String get templateFirstStep;

  /// No description provided for @templateFirstWalk.
  ///
  /// In en, this message translates to:
  /// **'First walk'**
  String get templateFirstWalk;

  /// No description provided for @templateFirstRun.
  ///
  /// In en, this message translates to:
  /// **'First run'**
  String get templateFirstRun;

  /// No description provided for @templateFirstBicycle.
  ///
  /// In en, this message translates to:
  /// **'First bicycle ride'**
  String get templateFirstBicycle;

  /// No description provided for @templateFirstWord.
  ///
  /// In en, this message translates to:
  /// **'First word'**
  String get templateFirstWord;

  /// No description provided for @templateFirstSentence.
  ///
  /// In en, this message translates to:
  /// **'First sentence'**
  String get templateFirstSentence;

  /// No description provided for @templateWroteOwnName.
  ///
  /// In en, this message translates to:
  /// **'Wrote own name'**
  String get templateWroteOwnName;

  /// No description provided for @deleteMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this milestone?'**
  String get deleteMilestoneTitle;

  /// No description provided for @deleteMilestoneMessage.
  ///
  /// In en, this message translates to:
  /// **'This milestone will be removed from this device.'**
  String get deleteMilestoneMessage;

  /// No description provided for @datePrecisionLabel.
  ///
  /// In en, this message translates to:
  /// **'How sure are you about the date?'**
  String get datePrecisionLabel;

  /// No description provided for @datePrecisionExact.
  ///
  /// In en, this message translates to:
  /// **'Exact date'**
  String get datePrecisionExact;

  /// No description provided for @datePrecisionMonth.
  ///
  /// In en, this message translates to:
  /// **'Month only'**
  String get datePrecisionMonth;

  /// No description provided for @datePrecisionYear.
  ///
  /// In en, this message translates to:
  /// **'Year only'**
  String get datePrecisionYear;

  /// No description provided for @datePrecisionApproximate.
  ///
  /// In en, this message translates to:
  /// **'Approximate'**
  String get datePrecisionApproximate;

  /// No description provided for @datePrecisionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get datePrecisionUnknown;

  /// No description provided for @datePrecisionPick.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get datePrecisionPick;

  /// No description provided for @datePrecisionPickMonth.
  ///
  /// In en, this message translates to:
  /// **'Choose month'**
  String get datePrecisionPickMonth;

  /// No description provided for @datePrecisionPickYear.
  ///
  /// In en, this message translates to:
  /// **'Choose year'**
  String get datePrecisionPickYear;

  /// No description provided for @firstWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'First words'**
  String get firstWordsTitle;

  /// No description provided for @firstWordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No first words yet.'**
  String get firstWordsEmpty;

  /// No description provided for @firstWordDetail.
  ///
  /// In en, this message translates to:
  /// **'First word'**
  String get firstWordDetail;

  /// No description provided for @firstWordField.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get firstWordField;

  /// No description provided for @firstWordRequired.
  ///
  /// In en, this message translates to:
  /// **'Word is required.'**
  String get firstWordRequired;

  /// No description provided for @firstWordLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get firstWordLanguage;

  /// No description provided for @firstWordLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Bangla, English…'**
  String get firstWordLanguageHint;

  /// No description provided for @firstWordContext.
  ///
  /// In en, this message translates to:
  /// **'Story / context'**
  String get firstWordContext;

  /// No description provided for @firstWordAudioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Audio coming later'**
  String get firstWordAudioPlaceholder;

  /// No description provided for @firstWordAudioHint.
  ///
  /// In en, this message translates to:
  /// **'Mark this for future audio recording support.'**
  String get firstWordAudioHint;

  /// No description provided for @saveFirstWord.
  ///
  /// In en, this message translates to:
  /// **'Save first word'**
  String get saveFirstWord;

  /// No description provided for @deleteFirstWordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this first word?'**
  String get deleteFirstWordTitle;

  /// No description provided for @deleteFirstWordMessage.
  ///
  /// In en, this message translates to:
  /// **'This first word will be removed from this device.'**
  String get deleteFirstWordMessage;

  /// No description provided for @addMemory.
  ///
  /// In en, this message translates to:
  /// **'Add memory'**
  String get addMemory;

  /// No description provided for @editMemory.
  ///
  /// In en, this message translates to:
  /// **'Edit memory'**
  String get editMemory;

  /// No description provided for @addMemorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write a story, mood, and photos.'**
  String get addMemorySubtitle;

  /// No description provided for @addFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Funny moment'**
  String get addFunnyMoment;

  /// No description provided for @editFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Edit funny moment'**
  String get editFunnyMoment;

  /// No description provided for @addFunnySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a quote or silly story.'**
  String get addFunnySubtitle;

  /// No description provided for @addAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get addAchievement;

  /// No description provided for @editAchievement.
  ///
  /// In en, this message translates to:
  /// **'Edit achievement'**
  String get editAchievement;

  /// No description provided for @addAchievementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Celebrate a proud win with photos.'**
  String get addAchievementSubtitle;

  /// No description provided for @quickTemplates.
  ///
  /// In en, this message translates to:
  /// **'Quick templates'**
  String get quickTemplates;

  /// No description provided for @templateSomethingFunny.
  ///
  /// In en, this message translates to:
  /// **'Something funny'**
  String get templateSomethingFunny;

  /// No description provided for @templateSomethingNew.
  ///
  /// In en, this message translates to:
  /// **'Something new'**
  String get templateSomethingNew;

  /// No description provided for @templateProudMoment.
  ///
  /// In en, this message translates to:
  /// **'Proud moment'**
  String get templateProudMoment;

  /// No description provided for @templateDifficultDay.
  ///
  /// In en, this message translates to:
  /// **'Difficult day'**
  String get templateDifficultDay;

  /// No description provided for @templateFavoriteMoment.
  ///
  /// In en, this message translates to:
  /// **'Favorite moment'**
  String get templateFavoriteMoment;

  /// No description provided for @templatePhotoMemory.
  ///
  /// In en, this message translates to:
  /// **'Photo memory'**
  String get templatePhotoMemory;

  /// No description provided for @memoryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get memoryDate;

  /// No description provided for @memoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get memoryTitle;

  /// No description provided for @memoryStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get memoryStory;

  /// No description provided for @memoryStoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a title or story to save this memory.'**
  String get memoryStoryRequired;

  /// No description provided for @memoryMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get memoryMood;

  /// No description provided for @memoryLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get memoryLocation;

  /// No description provided for @memoryTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get memoryTags;

  /// No description provided for @memoryTagsHint.
  ///
  /// In en, this message translates to:
  /// **'family, park, first time'**
  String get memoryTagsHint;

  /// No description provided for @saveMemory.
  ///
  /// In en, this message translates to:
  /// **'Save memory'**
  String get saveMemory;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodProud.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get moodProud;

  /// No description provided for @moodSilly.
  ///
  /// In en, this message translates to:
  /// **'Silly'**
  String get moodSilly;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful'**
  String get moodGrateful;

  /// No description provided for @attachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get attachmentsTitle;

  /// No description provided for @attachmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get attachmentsEmpty;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @funnyQuote.
  ///
  /// In en, this message translates to:
  /// **'Funny quote'**
  String get funnyQuote;

  /// No description provided for @funnyContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a quote, story, or title.'**
  String get funnyContentRequired;

  /// No description provided for @peoplePresent.
  ///
  /// In en, this message translates to:
  /// **'Who was there'**
  String get peoplePresent;

  /// No description provided for @saveFunnyMoment.
  ///
  /// In en, this message translates to:
  /// **'Save funny moment'**
  String get saveFunnyMoment;

  /// No description provided for @achievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get achievementTitle;

  /// No description provided for @achievementTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Achievement title is required.'**
  String get achievementTitleRequired;

  /// No description provided for @achievementCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get achievementCategory;

  /// No description provided for @achievementDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get achievementDescription;

  /// No description provided for @achievementAttachmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Attach a certificate or celebration photo.'**
  String get achievementAttachmentsHint;

  /// No description provided for @saveAchievement.
  ///
  /// In en, this message translates to:
  /// **'Save achievement'**
  String get saveAchievement;

  /// No description provided for @categorySchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get categorySchool;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @categoryArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get categoryArts;

  /// No description provided for @categorySocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get categorySocial;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @deleteMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get deleteMemoryTitle;

  /// No description provided for @deleteMemoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This memory will be removed from this device.'**
  String get deleteMemoryMessage;

  /// No description provided for @deleteFunnyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this funny moment?'**
  String get deleteFunnyTitle;

  /// No description provided for @deleteFunnyMessage.
  ///
  /// In en, this message translates to:
  /// **'This funny moment will be removed from this device.'**
  String get deleteFunnyMessage;

  /// No description provided for @deleteAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this achievement?'**
  String get deleteAchievementTitle;

  /// No description provided for @deleteAchievementMessage.
  ///
  /// In en, this message translates to:
  /// **'This achievement will be removed from this device.'**
  String get deleteAchievementMessage;

  /// No description provided for @discardDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardDraftTitle;

  /// No description provided for @discardDraftMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. If you leave now, they will be lost.'**
  String get discardDraftMessage;

  /// No description provided for @commonKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get commonKeepEditing;

  /// No description provided for @commonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get commonDiscard;

  /// No description provided for @kindJournal.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get kindJournal;

  /// No description provided for @kindFunny.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get kindFunny;

  /// No description provided for @kindAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement'**
  String get kindAchievement;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
