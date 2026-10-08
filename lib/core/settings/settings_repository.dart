import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_keys.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<AppSettings> load() async {
    final values = await _db.settingsDao.getAll();
    return AppSettings(
      language: AppLanguage.fromStorage(values[SettingsKeys.language]),
      themeMode: _themeFromStorage(values[SettingsKeys.themeMode]),
      onboardingComplete: values[SettingsKeys.onboardingComplete] == 'true',
      selectedChildId: _emptyToNull(values[SettingsKeys.selectedChildId]),
      heightUnit: HeightUnit.fromStorage(values[SettingsKeys.heightUnit]),
      weightUnit: WeightUnit.fromStorage(values[SettingsKeys.weightUnit]),
      temperatureUnit: TemperatureUnit.fromStorage(
        values[SettingsKeys.temperatureUnit],
      ),
      useBengaliDigits: values[SettingsKeys.useBengaliDigits] == 'true',
      // Default ON when unset (UX §31).
      notificationPrivacyMode:
          values[SettingsKeys.notificationPrivacyMode] != 'false',
      flagSecure: values[SettingsKeys.flagSecure] == 'true',
    );
  }

  Future<void> save(AppSettings settings) {
    return _db.settingsDao.setValues({
      SettingsKeys.language: settings.language.name,
      SettingsKeys.themeMode: settings.themeMode.name,
      SettingsKeys.onboardingComplete: '${settings.onboardingComplete}',
      SettingsKeys.selectedChildId: settings.selectedChildId ?? '',
      SettingsKeys.heightUnit: settings.heightUnit.name,
      SettingsKeys.weightUnit: settings.weightUnit.name,
      SettingsKeys.temperatureUnit: settings.temperatureUnit.name,
      SettingsKeys.useBengaliDigits: '${settings.useBengaliDigits}',
      SettingsKeys.notificationPrivacyMode:
          '${settings.notificationPrivacyMode}',
      SettingsKeys.flagSecure: '${settings.flagSecure}',
    }, DateTime.now().toUtc());
  }

  ThemeMode _themeFromStorage(String? value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  String? _emptyToNull(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
