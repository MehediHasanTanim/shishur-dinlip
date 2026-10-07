import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/development/growth_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class GrowthHistoryScreen extends ConsumerWidget {
  const GrowthHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn = settings?.useBengaliDigits ?? false;
    final heightUnit = settings?.heightUnit ?? HeightUnit.cm;
    final weightUnit = settings?.weightUnit ?? WeightUnit.kg;
    final historyAsync = ref.watch(growthHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.growthHistory)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.growthCreate),
        child: const Icon(Icons.add),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.growthEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final height = UnitConversion.formatHeight(
                heightCm: item.record.heightCm,
                unit: heightUnit,
                bangla: bangla,
                useBengaliDigits: useBn,
              );
              final weight = UnitConversion.formatWeight(
                weightKg: item.record.weightKg,
                unit: weightUnit,
                bangla: bangla,
                useBengaliDigits: useBn,
              );
              final deltaH = UnitConversion.formatDeltaHeight(
                deltaCm: item.heightDeltaCm,
                unit: heightUnit,
                bangla: bangla,
                useBengaliDigits: useBn,
              );
              final deltaW = UnitConversion.formatDeltaWeight(
                deltaKg: item.weightDeltaKg,
                unit: weightUnit,
                bangla: bangla,
                useBengaliDigits: useBn,
              );
              final deltas = [
                if (deltaH.isNotEmpty) deltaH,
                if (deltaW.isNotEmpty) deltaW,
              ].join(' · ');

              return Card(
                child: ListTile(
                  title: Text(
                    MaterialLocalizations.of(
                      context,
                    ).formatMediumDate(item.record.measuredAt),
                  ),
                  subtitle: Text(
                    [
                      '$height · $weight',
                      if (deltas.isNotEmpty) deltas,
                    ].join('\n'),
                  ),
                  isThreeLine: deltas.isNotEmpty,
                  onTap: () => context.push(
                    AppRoutes.growthDetailPath(item.record.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
