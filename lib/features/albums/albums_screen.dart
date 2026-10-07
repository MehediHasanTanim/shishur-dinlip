import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/features/albums/albums_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final albumsAsync = ref.watch(customAlbumsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.albumsTitle),
        actions: [
          IconButton(
            tooltip: l10n.yearReviewTitle,
            onPressed: () => context.push(AppRoutes.yearReview),
            icon: const Icon(Icons.auto_stories_outlined),
          ),
          IconButton(
            tooltip: l10n.photosTitle,
            onPressed: () => context.push(AppRoutes.photos),
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.albumCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addAlbum),
      ),
      body: albumsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (albums) {
          if (albums.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_album_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.albumsEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.yearReview),
                      child: Text(l10n.yearReviewTitle),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.photos),
                      child: Text(l10n.photosTitle),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: albums.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.auto_stories_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(l10n.yearReviewTitle),
                    subtitle: Text(l10n.yearReviewSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.yearReview),
                  ),
                );
              }
              final album = albums[index - 1];
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.photo_album_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(album.title),
                  subtitle: Text(_themeLabel(l10n, album.theme)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push(AppRoutes.albumDetailPath(album.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, String? theme) {
    return switch (theme) {
      AlbumThemes.minimal => l10n.albumThemeMinimal,
      AlbumThemes.playful => l10n.albumThemePlayful,
      AlbumThemes.colorful => l10n.albumThemeColorful,
      AlbumThemes.elegant => l10n.albumThemeElegant,
      _ => theme ?? l10n.commonNone,
    };
  }
}
