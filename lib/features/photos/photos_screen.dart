import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/photo_library_item.dart';
import 'package:shishur_dinlipi/features/photos/photos_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_thumbnail.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final groupBy = ref.watch(photoLibraryGroupByProvider);
    final groupsAsync = ref.watch(photoLibraryGroupsProvider);
    final showHeaders = groupBy == PhotoLibraryGroupBy.year ||
        groupBy == PhotoLibraryGroupBy.age ||
        groupBy == PhotoLibraryGroupBy.category;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.photosTitle)),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final option in PhotoLibraryGroupBy.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_groupLabel(l10n, option)),
                      selected: groupBy == option,
                      onSelected: (_) {
                        ref.read(photoLibraryGroupByProvider.notifier).state =
                            option;
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: groupsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.errorGeneric)),
              data: (groups) {
                final allItems = groups.values.expand((e) => e).toList();
                if (allItems.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.photosEmpty,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                if (!showHeaders) {
                  return _PhotoGrid(items: allItems);
                }

                return CustomScrollView(
                  slivers: [
                    for (final entry in groups.entries) ...[
                      if (entry.key != 'all')
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              entry.key,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = entry.value[index];
                              return _PhotoTile(item: item);
                            },
                            childCount: entry.value.length,
                          ),
                        ),
                      ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _groupLabel(AppLocalizations l10n, PhotoLibraryGroupBy groupBy) {
    return switch (groupBy) {
      PhotoLibraryGroupBy.all => l10n.photosAll,
      PhotoLibraryGroupBy.favorites => l10n.photosFavorites,
      PhotoLibraryGroupBy.year => l10n.photosByYear,
      PhotoLibraryGroupBy.age => l10n.photosByAge,
      PhotoLibraryGroupBy.category => l10n.photosByCategory,
    };
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.items});

  final List<PhotoLibraryItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _PhotoTile(item: items[index]),
    );
  }
}

class _PhotoTile extends ConsumerWidget {
  const _PhotoTile({required this.item});

  final PhotoLibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).photosTitle,
      child: InkWell(
        onTap: () => context.push(AppRoutes.photoDetailPath(item.media.id)),
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.fileMissing)
                ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              else
                AppThumbnail(
                  storage: ref.read(fileStorageServiceProvider),
                  asset: item.media,
                  borderRadius: 0,
                ),
              if (item.isFavorite)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.pinkAccent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
