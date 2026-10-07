import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/feature_placeholder.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeaturePlaceholder(
      title: l10n.timelineTitle,
      message: l10n.timelinePlaceholder,
      icon: Icons.timeline_rounded,
    );
  }
}
