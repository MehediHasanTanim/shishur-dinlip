import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/health/allergy_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/health/widgets/health_disclaimer.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AllergyDetailScreen extends ConsumerStatefulWidget {
  const AllergyDetailScreen({super.key, required this.allergyId});

  final String allergyId;

  @override
  ConsumerState<AllergyDetailScreen> createState() =>
      _AllergyDetailScreenState();
}

class _AllergyDetailScreenState extends ConsumerState<AllergyDetailScreen> {
  Allergy? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(allergiesRepositoryProvider)
        .getById(widget.allergyId);
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.allergyDeleteConfirm),
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
      await ref.read(allergiesRepositoryProvider).softDelete(widget.allergyId);
      ref.invalidate(allergiesProvider);
      ref.invalidate(healthSummaryProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, e))),
      );
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
        title: Text(item.allergen),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.allergyEditPath(item.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.allergyType),
            subtitle: Text(allergyTypeLabel(l10n, item.allergyType)),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.allergySeverity),
            subtitle: Text(allergySeverityLabel(l10n, item.severity)),
          ),
          if (item.reaction != null && item.reaction!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.allergyReaction),
              subtitle: Text(item.reaction!),
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.allergyFirstObserved),
            subtitle: Text(
              item.firstObserved == null
                  ? l10n.commonNone
                  : dateFmt.formatMediumDate(item.firstObserved!),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.allergyDoctorConfirmed),
            subtitle: Text(item.doctorConfirmed ? l10n.commonYes : l10n.commonNo),
          ),
          if (item.notes != null && item.notes!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.allergyNotes),
              subtitle: Text(item.notes!),
            ),
          const SizedBox(height: 16),
          const HealthDisclaimer(),
        ],
      ),
    );
  }
}
