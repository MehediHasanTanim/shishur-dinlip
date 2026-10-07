import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.memory();
  });

  tearDown(() async {
    await db.close();
  });

  test('creates schema at current version', () async {
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data['user_version'], AppDatabase.currentSchemaVersion);
  });

  test('children repository save and soft delete', () async {
    final repo = DriftChildrenRepository(db);
    final now = DateTime.utc(2024, 1, 1);
    final child = Child(
      id: idGenerator.next(),
      name: 'Azwad',
      dateOfBirth: DateTime.utc(2020, 3, 15),
      createdAt: now,
      updatedAt: now,
    );

    final saved = await repo.save(child);
    expect(saved.name, 'Azwad');

    final loaded = await repo.getById(saved.id);
    expect(loaded?.name, 'Azwad');

    await repo.softDelete(saved.id);
    expect(await repo.getById(saved.id), isNull);
    expect(await repo.getChildren(), isEmpty);
  });

  test('settings survive reload from database', () async {
    final repo = SettingsRepository(db);
    const settings = AppSettings(
      language: AppLanguage.bangla,
      themeMode: ThemeMode.dark,
      onboardingComplete: true,
      selectedChildId: 'child-1',
      heightUnit: HeightUnit.ftIn,
      weightUnit: WeightUnit.lb,
      temperatureUnit: TemperatureUnit.fahrenheit,
      useBengaliDigits: true,
    );

    await repo.save(settings);
    final loaded = await repo.load();

    expect(loaded.language, AppLanguage.bangla);
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.onboardingComplete, isTrue);
    expect(loaded.selectedChildId, 'child-1');
    expect(loaded.heightUnit, HeightUnit.ftIn);
    expect(loaded.weightUnit, WeightUnit.lb);
    expect(loaded.temperatureUnit, TemperatureUnit.fahrenheit);
    expect(loaded.useBengaliDigits, isTrue);
  });

  test('transaction helper commits writes', () async {
    await db.runInTransaction(() async {
      await db.settingsDao.setValue('k', 'v', DateTime.now().toUtc());
    });
    expect(await db.settingsDao.getValue('k'), 'v');
  });
}
