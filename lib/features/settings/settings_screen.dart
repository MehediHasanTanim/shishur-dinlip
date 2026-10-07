import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final settings = settingsAsync.valueOrNull ?? const AppSettings();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.settingsLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<AppLanguage>(
            segments: [
              ButtonSegment(
                value: AppLanguage.system,
                label: Text(l10n.settingsThemeSystem),
              ),
              ButtonSegment(
                value: AppLanguage.english,
                label: Text(l10n.settingsLanguageEnglish),
              ),
              ButtonSegment(
                value: AppLanguage.bangla,
                label: Text(l10n.settingsLanguageBangla),
              ),
            ],
            selected: {settings.language},
            onSelectionChanged: (value) {
              controller.setLanguage(value.first);
            },
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsAppearance,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.settingsThemeSystem),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.settingsThemeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.settingsThemeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (value) {
              controller.setThemeMode(value.first);
            },
          ),
          const SizedBox(height: 24),
          Text('Units', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Height'),
            trailing: DropdownButton<HeightUnit>(
              value: settings.heightUnit,
              items: const [
                DropdownMenuItem(value: HeightUnit.cm, child: Text('cm')),
                DropdownMenuItem(value: HeightUnit.ftIn, child: Text('ft/in')),
              ],
              onChanged: (value) {
                if (value != null) controller.setHeightUnit(value);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Weight'),
            trailing: DropdownButton<WeightUnit>(
              value: settings.weightUnit,
              items: const [
                DropdownMenuItem(value: WeightUnit.kg, child: Text('kg')),
                DropdownMenuItem(value: WeightUnit.lb, child: Text('lb')),
              ],
              onChanged: (value) {
                if (value != null) controller.setWeightUnit(value);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Temperature'),
            trailing: DropdownButton<TemperatureUnit>(
              value: settings.temperatureUnit,
              items: const [
                DropdownMenuItem(
                  value: TemperatureUnit.celsius,
                  child: Text('°C'),
                ),
                DropdownMenuItem(
                  value: TemperatureUnit.fahrenheit,
                  child: Text('°F'),
                ),
              ],
              onChanged: (value) {
                if (value != null) controller.setTemperatureUnit(value);
              },
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bengali digits'),
            subtitle: const Text('Show numbers using বাংলা digits when useful'),
            value: settings.useBengaliDigits,
            onChanged: controller.setUseBengaliDigits,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsAbout,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.appNameBn),
            subtitle: Text(
              l10n.settingsVersion(
                '${AppConfig.versionName}+${AppConfig.versionCode}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
