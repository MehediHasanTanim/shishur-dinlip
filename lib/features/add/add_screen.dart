import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/feature_placeholder.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeaturePlaceholder(
      title: l10n.addTitle,
      message: l10n.addPlaceholder,
      icon: Icons.add_circle_outline_rounded,
    );
  }
}
