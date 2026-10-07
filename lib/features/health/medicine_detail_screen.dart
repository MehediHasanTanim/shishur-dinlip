import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicineDetailScreen extends ConsumerStatefulWidget {
  const MedicineDetailScreen({super.key, required this.medicineId});

  final String medicineId;

  @override
  ConsumerState<MedicineDetailScreen> createState() =>
      _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  Medicine? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(medicinesRepositoryProvider)
        .getById(widget.medicineId);
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.medicineEditPath(item.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(item),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Chip(label: Text(medicineStatusLabel(l10n, item.status))),
          const SizedBox(height: 12),
          if (item.strength != null)
            _DetailRow(label: l10n.medicineStrength, value: item.strength!),
          if (item.dosage != null)
            _DetailRow(label: l10n.medicineDose, value: item.dosage!),
          if (item.frequencyText != null)
            _DetailRow(
              label: l10n.medicineFrequency,
              value: item.frequencyText!,
            ),
          if (item.startDate != null)
            _DetailRow(
              label: l10n.medicineStartDate,
              value: dateFmt.formatFullDate(item.startDate!),
            ),
          if (item.endDate != null)
            _DetailRow(
              label: l10n.medicineEndDate,
              value: dateFmt.formatFullDate(item.endDate!),
            ),
          if (item.reason != null)
            _DetailRow(label: l10n.medicineReason, value: item.reason!),
          if (item.prescribedBy != null)
            _DetailRow(
              label: l10n.medicinePrescriber,
              value: item.prescribedBy!,
            ),
          if (item.schedules.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.medicineSchedule,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            for (final schedule in item.schedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(schedule.timeOfDay),
              ),
          ],
          if (item.notes != null) ...[
            const SizedBox(height: 8),
            Text(l10n.commonNotes, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(item.notes!),
          ],
        ],
      ),
    );
  }

  Future<void> _delete(Medicine item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedicineTitle),
        content: Text(l10n.deleteMedicineMessage),
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
      await ref.read(medicinesRepositoryProvider).softDelete(item.id);
      ref.invalidate(medicinesProvider);
      ref.invalidate(activeMedicinesProvider);
      ref.invalidate(healthSummaryProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
