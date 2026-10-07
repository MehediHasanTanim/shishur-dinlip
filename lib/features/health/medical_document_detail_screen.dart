import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicalDocumentDetailScreen extends ConsumerStatefulWidget {
  const MedicalDocumentDetailScreen({super.key, required this.documentId});

  final String documentId;

  @override
  ConsumerState<MedicalDocumentDetailScreen> createState() =>
      _MedicalDocumentDetailScreenState();
}

class _MedicalDocumentDetailScreenState
    extends ConsumerState<MedicalDocumentDetailScreen> {
  MedicalDocument? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(medicalDocumentsRepositoryProvider)
        .getById(widget.documentId);
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
    final media = item.media;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.medicalDocumentEditPath(item.id));
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
          Chip(
            label: Text(medicalDocumentTypeLabel(l10n, item.documentType)),
          ),
          const SizedBox(height: 12),
          if (item.documentDate != null)
            _DetailRow(
              label: l10n.medicalDocDate,
              value: dateFmt.formatFullDate(item.documentDate!),
            ),
          if (media?.originalFilename != null)
            _DetailRow(
              label: l10n.medicalDocPickFile,
              value: media!.originalFilename!,
            ),
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

  Future<void> _delete(MedicalDocument item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedicalDocumentTitle),
        content: Text(l10n.deleteMedicalDocumentMessage),
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
      await ref.read(medicalDocumentsRepositoryProvider).softDelete(item.id);
      ref.invalidate(medicalDocumentsProvider);
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
