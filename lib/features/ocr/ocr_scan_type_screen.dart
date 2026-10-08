import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/features/ocr/ocr_labels.dart';
import 'package:shishur_dinlipi/features/ocr/ocr_script_picker.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OcrScanTypeScreen extends StatelessWidget {
  const OcrScanTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ocrTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(
            l10n.ocrSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ocrPrivacyNote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          const OcrScriptPicker(),
          const SizedBox(height: 16),
          for (final type in OcrScanType.values) ...[
            Card(
              child: ListTile(
                leading: Icon(_icon(type)),
                title: Text(ocrScanTypeLabel(l10n, type)),
                subtitle: Text(ocrScanTypeSubtitle(l10n, type)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.ocrCapturePath(type.name)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  IconData _icon(OcrScanType type) {
    return switch (type) {
      OcrScanType.vaccinationCard => Icons.vaccines_outlined,
      OcrScanType.prescription => Icons.medication_outlined,
      OcrScanType.diagnosticReport => Icons.biotech_outlined,
    };
  }
}
