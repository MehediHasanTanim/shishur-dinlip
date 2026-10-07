import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/photos/photos_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class PhotoDetailScreen extends ConsumerWidget {
  const PhotoDetailScreen({super.key, required this.photoId});

  final String photoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(photoLibraryItemProvider(photoId));

    return async.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.photoMissing)),
          );
        }

        final favorite = item.isFavorite;

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: favorite ? l10n.photoUnfavorite : l10n.photoFavorite,
                onPressed: () => _toggleFavorite(context, ref, favorite),
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
            ],
          ),
          body: item.fileMissing
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.photoMissing,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : FutureBuilder<File>(
                  future: ref
                      .read(fileStorageServiceProvider)
                      .absoluteFile(item.media.localPath),
                  builder: (context, snapshot) {
                    final file = snapshot.data;
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (file == null || !file.existsSync()) {
                      return Center(child: Text(l10n.photoMissing));
                    }
                    return InteractiveViewer(
                      child: Center(
                        child: Image.file(file, fit: BoxFit.contain),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    bool currentlyFavorite,
  ) async {
    try {
      await ref.read(photoLibraryServiceProvider).setFavorite(
            photoId,
            !currentlyFavorite,
          );
      ref.invalidate(photoLibraryItemProvider(photoId));
      ref.invalidate(photoLibraryGroupsProvider);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
