import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_highlight.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/ocr/ocr_labels.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OcrReviewScreen extends ConsumerStatefulWidget {
  const OcrReviewScreen({super.key, required this.draft});

  final OcrReviewDraft draft;

  @override
  ConsumerState<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends ConsumerState<OcrReviewScreen> {
  late OcrReviewDraft _draft;
  late final Map<String, TextEditingController> _controllers;
  var _busy = false;
  var _acknowledged = false;

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    _controllers = {
      for (final f in _draft.fields)
        f.key: TextEditingController(text: f.value),
    };
    // Ensure notes field exists for parent comments.
    if (!_controllers.containsKey(OcrFieldKeys.notes)) {
      _controllers[OcrFieldKeys.notes] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  OcrReviewDraft _buildEditedDraft({required bool confirmed}) {
    var fields = [
      for (final f in _draft.fields)
        f.copyWith(value: _controllers[f.key]?.text ?? f.value),
    ];
    final notes = _controllers[OcrFieldKeys.notes]?.text.trim() ?? '';
    if (notes.isNotEmpty &&
        !fields.any((f) => f.key == OcrFieldKeys.notes)) {
      fields = [
        ...fields,
        OcrExtractedField(
          key: OcrFieldKeys.notes,
          labelKey: 'ocrFieldNotes',
          value: notes,
        ),
      ];
    } else if (notes.isNotEmpty) {
      fields = [
        for (final f in fields)
          if (f.key == OcrFieldKeys.notes) f.copyWith(value: notes) else f,
      ];
    }
    final draft = OcrReviewDraft(
      scanType: _draft.scanType,
      imagePath: _draft.imagePath,
      raw: _draft.raw,
      fields: fields,
      confirmed: confirmed,
    );
    return confirmed ? draft.markConfirmed() : draft;
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context);
    if (!_acknowledged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ocrConfirmRequired)),
      );
      return;
    }
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() => _busy = true);
    try {
      final draft = _buildEditedDraft(confirmed: true);
      final result = await ref.read(ocrConfirmServiceProvider).confirmAndSave(
            childId: child.id,
            draft: draft,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ocrSaved)),
      );
      final path = switch (result.scanType) {
        OcrScanType.vaccinationCard =>
          AppRoutes.vaccinationDetailPath(result.entityId),
        OcrScanType.prescription =>
          AppRoutes.medicineDetailPath(result.entityId),
        OcrScanType.diagnosticReport =>
          AppRoutes.medicalDocumentDetailPath(result.entityId),
      };
      context.go(path);
    } on AppFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ocrReviewTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          Text(
            l10n.ocrReviewSubtitle,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ocrNeverAutoSave,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (File(_draft.imagePath).existsSync())
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_draft.imagePath),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Text(l10n.ocrExtractedText, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _draft.raw.fullText.trim().isEmpty
                ? Text(l10n.ocrNoTextFound)
                : Text.rich(
                    TextSpan(
                      children: ocrHighlightSpans(
                        _draft.raw.fullText,
                        _draft.fields,
                        base: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Text(l10n.ocrExtractedFields, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_draft.fields.isEmpty)
            Text(l10n.ocrNoFieldsHint)
          else
            for (final field in _draft.fields) ...[
              TextFormField(
                controller: _controllers[field.key],
                decoration: InputDecoration(
                  labelText: ocrFieldLabel(l10n, field.labelKey),
                  border: const OutlineInputBorder(),
                  suffixIcon: field.matchedText == null
                      ? null
                      : const Icon(Icons.auto_awesome_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 12),
            ],
          TextFormField(
            controller: _controllers[OcrFieldKeys.notes],
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.ocrFieldNotes,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _acknowledged,
            onChanged: _busy
                ? null
                : (v) => setState(() => _acknowledged = v ?? false),
            title: Text(l10n.ocrConfirmCheckbox),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _busy ? null : _confirm,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(l10n.ocrConfirmSave),
          ),
        ),
      ),
    );
  }
}
