import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/growth_record.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/development/growth_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class GrowthDetailScreen extends ConsumerStatefulWidget {
  const GrowthDetailScreen({super.key, required this.recordId});

  final String recordId;

  @override
  ConsumerState<GrowthDetailScreen> createState() => _GrowthDetailScreenState();
}

class _GrowthDetailScreenState extends ConsumerState<GrowthDetailScreen> {
  GrowthRecord? _record;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final record = await ref
        .read(growthRepositoryProvider)
        .getById(widget.recordId);
    if (mounted) {
      setState(() {
        _record = record;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn = settings?.useBengaliDigits ?? false;
    final heightUnit = settings?.heightUnit ?? HeightUnit.cm;
    final weightUnit = settings?.weightUnit ?? WeightUnit.kg;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final record = _record;
    if (record == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.growthDetail),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.growthEditPath(record.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(record),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            MaterialLocalizations.of(context).formatFullDate(record.measuredAt),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            UnitConversion.formatHeight(
              heightCm: record.heightCm,
              unit: heightUnit,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            UnitConversion.formatWeight(
              weightKg: record.weightKg,
              unit: weightUnit,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (record.measurementLocation != null) ...[
            const SizedBox(height: 16),
            Text('${l10n.memoryLocation}: ${record.measurementLocation}'),
          ],
          if (record.notes != null) ...[
            const SizedBox(height: 12),
            Text(record.notes!),
          ],
        ],
      ),
    );
  }

  Future<void> _delete(GrowthRecord record) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteGrowthTitle),
        content: Text(l10n.deleteGrowthMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(growthRepositoryProvider).softDelete(record.id);
      ref.invalidate(growthHistoryProvider);
      ref.invalidate(latestGrowthProvider);
      ref.invalidate(growthChartProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
