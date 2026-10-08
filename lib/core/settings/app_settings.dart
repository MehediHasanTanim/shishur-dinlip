import 'package:flutter/material.dart';

enum AppLanguage {
  system,
  english,
  bangla;

  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.english => const Locale('en'),
    AppLanguage.bangla => const Locale('bn'),
  };

  static AppLanguage fromStorage(String? value) {
    return AppLanguage.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppLanguage.system,
    );
  }
}

enum HeightUnit {
  cm,
  ftIn;

  static HeightUnit fromStorage(String? value) => HeightUnit.values.firstWhere(
    (item) => item.name == value,
    orElse: () => HeightUnit.cm,
  );
}

enum WeightUnit {
  kg,
  lb;

  static WeightUnit fromStorage(String? value) => WeightUnit.values.firstWhere(
    (item) => item.name == value,
    orElse: () => WeightUnit.kg,
  );
}

enum TemperatureUnit {
  celsius,
  fahrenheit;

  static TemperatureUnit fromStorage(String? value) =>
      TemperatureUnit.values.firstWhere(
        (item) => item.name == value,
        orElse: () => TemperatureUnit.celsius,
      );
}

@immutable
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.themeMode = ThemeMode.system,
    this.onboardingComplete = false,
    this.selectedChildId,
    this.heightUnit = HeightUnit.cm,
    this.weightUnit = WeightUnit.kg,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.useBengaliDigits = false,
    this.notificationPrivacyMode = true,
    this.flagSecure = false,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final bool onboardingComplete;
  final String? selectedChildId;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final TemperatureUnit temperatureUnit;
  final bool useBengaliDigits;

  /// When true, lock-screen notifications omit child/medical detail.
  final bool notificationPrivacyMode;

  /// When true, Android blocks screenshots / recent-app previews (FLAG_SECURE).
  final bool flagSecure;

  AppSettings copyWith({
    AppLanguage? language,
    ThemeMode? themeMode,
    bool? onboardingComplete,
    String? selectedChildId,
    bool clearSelectedChildId = false,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
    TemperatureUnit? temperatureUnit,
    bool? useBengaliDigits,
    bool? notificationPrivacyMode,
    bool? flagSecure,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      selectedChildId: clearSelectedChildId
          ? null
          : (selectedChildId ?? this.selectedChildId),
      heightUnit: heightUnit ?? this.heightUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      useBengaliDigits: useBengaliDigits ?? this.useBengaliDigits,
      notificationPrivacyMode:
          notificationPrivacyMode ?? this.notificationPrivacyMode,
      flagSecure: flagSecure ?? this.flagSecure,
    );
  }
}
