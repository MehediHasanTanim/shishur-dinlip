import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/development/growth_providers.dart';
import 'package:shishur_dinlipi/features/development/widgets/growth_chart.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class GrowthOverviewScreen extends ConsumerStatefulWidget {
  const GrowthOverviewScreen({super.key});

  @override
  ConsumerState<GrowthOverviewScreen> createState() =>
      _GrowthOverviewScreenState();
}

class _GrowthOverviewScreenState extends ConsumerState<GrowthOverviewScreen> {
  GrowthChartRange _range = GrowthChartRange.oneYear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn = settings?.useBengaliDigits ?? false;
    final heightUnit = settings?.heightUnit ?? HeightUnit.cm;
    final weightUnit = settings?.weightUnit ?? WeightUnit.kg;
    final latestAsync = ref.watch(latestGrowthProvider);
    final chartAsync = ref.watch(growthChartProvider(_range));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.growthTitle),
        actions: [
          IconButton(
            tooltip: l10n.growthHistory,
            onPressed: () => context.push(AppRoutes.growthHistory),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.growthCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addGrowth),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          latestAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (latest) {
              if (latest == null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.growthEmpty),
                  ),
                );
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          label: l10n.growthHeight,
                          value: UnitConversion.formatHeight(
                            heightCm: latest.heightCm,
                            unit: heightUnit,
                            bangla: bangla,
                            useBengaliDigits: useBn,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          label: l10n.growthWeight,
                          value: UnitConversion.formatWeight(
                            weightKg: latest.weightKg,
                            unit: weightUnit,
                            bangla: bangla,
                            useBengaliDigits: useBn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SegmentedButton<GrowthChartRange>(
            segments: [
              ButtonSegment(
                value: GrowthChartRange.sixMonths,
                label: Text(l10n.growthRange6m),
              ),
              ButtonSegment(
                value: GrowthChartRange.oneYear,
                label: Text(l10n.growthRange1y),
              ),
              ButtonSegment(
                value: GrowthChartRange.all,
                label: Text(l10n.growthRangeAll),
              ),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
          const SizedBox(height: 16),
          Text(l10n.growthHeightChart, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          chartAsync.when(
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (records) => GrowthLineChart(
              records: records,
              metric: GrowthChartMetric.height,
              heightUnit: heightUnit,
              weightUnit: weightUnit,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.growthWeightChart, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          chartAsync.when(
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (records) => GrowthLineChart(
              records: records,
              metric: GrowthChartMetric.weight,
              heightUnit: heightUnit,
              weightUnit: weightUnit,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}
