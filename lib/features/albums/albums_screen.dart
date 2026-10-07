import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/feature_placeholder.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeaturePlaceholder(
      title: l10n.albumsTitle,
      message: l10n.albumsPlaceholder,
      icon: Icons.photo_album_outlined,
    );
  }
}
