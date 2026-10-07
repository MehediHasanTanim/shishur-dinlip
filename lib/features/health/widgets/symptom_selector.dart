import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Multi-select [FilterChip]s for [IllnessSymptoms.all].
class SymptomSelector extends StatelessWidget {
  const SymptomSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final symptom in IllnessSymptoms.all)
          FilterChip(
            label: Text(illnessSymptomLabel(l10n, symptom)),
            selected: selected.contains(symptom),
            onSelected: (isSelected) {
              final next = Set<String>.from(selected);
              if (isSelected) {
                next.add(symptom);
              } else {
                next.remove(symptom);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}
