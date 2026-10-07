import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

enum GrowthChartMetric { height, weight }

class GrowthLineChart extends StatelessWidget {
  const GrowthLineChart({
    super.key,
    required this.records,
    required this.metric,
    required this.heightUnit,
    required this.weightUnit,
    required this.bangla,
    required this.useBengaliDigits,
  });

  final List<GrowthRecord> records;
  final GrowthChartMetric metric;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final bool bangla;
  final bool useBengaliDigits;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = <FlSpot>[];
    final labels = <int, DateTime>{};

    for (var i = 0; i < records.length; i++) {
      final record = records[i];
      final value = metric == GrowthChartMetric.height
          ? record.heightCm
          : record.weightKg;
      if (value == null) continue;
      final y = metric == GrowthChartMetric.height
          ? (heightUnit == HeightUnit.cm
                ? value
                : UnitConversion.cmToInches(value))
          : (weightUnit == WeightUnit.kg
                ? value
                : UnitConversion.kgToLb(value));
      points.add(FlSpot(i.toDouble(), y));
      labels[i] = record.measuredAt;
    }

    if (points.length < 2) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            l10n.growthChartNeedMore,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final locale = bangla ? 'bn' : 'en';
    final dateFmt = DateFormat.MMMd(locale);

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (records.length - 1).toDouble(),
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    UnitConversion.roundDisplay(value).toStringAsFixed(0),
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  final date = labels[i];
                  if (date == null) return const SizedBox.shrink();
                  if (i != 0 && i != labels.keys.last && i % 2 != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dateFmt.format(date),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touched) {
                return touched.map((spot) {
                  final date = labels[spot.x.round()];
                  final unit = metric == GrowthChartMetric.height
                      ? (heightUnit == HeightUnit.cm ? 'cm' : 'in')
                      : (weightUnit == WeightUnit.kg ? 'kg' : 'lb');
                  final value = UnitConversion.roundDisplay(
                    spot.y,
                  ).toStringAsFixed(1);
                  final dateText = date == null ? '' : dateFmt.format(date);
                  return LineTooltipItem(
                    '$dateText\n$value $unit',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
