import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<AppSettings> {
  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  Future<AppSettings> build() {
    return _repository.load();
  }

  Future<void> _persist(AppSettings next) async {
    state = AsyncData(next);
    await _repository.save(next);
  }

  Future<void> setLanguage(AppLanguage language) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(language: language));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(themeMode: themeMode));
  }

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(onboardingComplete: true));
  }

  Future<void> setSelectedChildId(String? childId) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(
      current.copyWith(
        selectedChildId: childId,
        clearSelectedChildId: childId == null,
      ),
    );
  }

  Future<void> setHeightUnit(HeightUnit unit) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(heightUnit: unit));
  }

  Future<void> setWeightUnit(WeightUnit unit) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(weightUnit: unit));
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(temperatureUnit: unit));
  }

  Future<void> setUseBengaliDigits(bool enabled) async {
    final current = state.valueOrNull ?? await _repository.load();
    await _persist(current.copyWith(useBengaliDigits: enabled));
  }
}

/// Future app-lock gate. Defaults unlocked until security sprint wires PIN/biometrics.
final appUnlockedProvider = StateProvider<bool>((ref) => true);
