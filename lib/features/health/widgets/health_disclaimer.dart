import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Soft medical disclaimer card; tap opens the full disclaimer dialog.
class HealthDisclaimer extends StatelessWidget {
  const HealthDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showFull(context, l10n),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: scheme.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.healthDisclaimerShort,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFull(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.healthTitle),
        content: SingleChildScrollView(
          child: Text(l10n.healthDisclaimerFull),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );
  }
}
