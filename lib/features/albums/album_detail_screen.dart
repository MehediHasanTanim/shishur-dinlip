import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/photo_library_item.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/albums/albums_providers.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AlbumDetailScreen extends ConsumerStatefulWidget {
  const AlbumDetailScreen({super.key, required this.albumId});

  final String albumId;

  @override
  ConsumerState<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends ConsumerState<AlbumDetailScreen> {
  List<AlbumItem>? _localItems;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(albumDetailProvider(widget.albumId));

    return async.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      ),
      data: (album) {
        if (album == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.errorGeneric)),
          );
        }

        final items = _localItems ?? album.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(album.title),
            actions: [
              IconButton(
                tooltip: l10n.editAlbum,
                onPressed: () async {
                  await context.push(AppRoutes.albumEditPath(album.id));
                  ref.invalidate(albumDetailProvider(widget.albumId));
                  setState(() => _localItems = null);
                },
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: l10n.commonDelete,
                onPressed: () => _deleteAlbum(album),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addPhotos(album),
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(l10n.albumAddPhotos),
          ),
          body: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.albumNoItems,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: items.length,
                  onReorderItem: (oldIndex, newIndex) =>
                      _reorder(album, items, oldIndex, newIndex),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isCover = album.coverAssetId == item.entityId;
                    return Card(
                      key: ValueKey(item.id),
                      child: ListTile(
                        leading: _AlbumItemThumb(mediaId: item.entityId),
                        title: Text(
                          item.customCaption?.isNotEmpty == true
                              ? item.customCaption!
                              : item.entityId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: isCover ? Text(l10n.albumCover) : null,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            switch (value) {
                              case 'cover':
                                _setCover(album, item.entityId);
                              case 'open':
                                context.push(
                                  AppRoutes.photoDetailPath(item.entityId),
                                );
                              case 'remove':
                                _removeItem(item);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'cover',
                              child: Text(l10n.albumCover),
                            ),
                            PopupMenuItem(
                              value: 'open',
                              child: Text(l10n.photosTitle),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Text(l10n.commonDelete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Future<void> _reorder(
    Album album,
    List<AlbumItem> items,
    int oldIndex,
    int newIndex,
  ) async {
    // newIndex is already post-removal (onReorderItem).
    final next = [...items];
    final moved = next.removeAt(oldIndex);
    next.insert(newIndex, moved);
    setState(() => _localItems = next);
    try {
      await ref.read(albumsRepositoryProvider).reorderItems(
            album.id,
            next.map((e) => e.id).toList(),
          );
      ref.invalidate(albumDetailProvider(widget.albumId));
    } catch (error) {
      if (!mounted) return;
      setState(() => _localItems = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _setCover(Album album, String mediaId) async {
    try {
      await ref.read(albumsRepositoryProvider).setCover(album.id, mediaId);
      ref.invalidate(albumDetailProvider(widget.albumId));
      ref.invalidate(customAlbumsProvider);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _removeItem(AlbumItem item) async {
    try {
      await ref.read(albumsRepositoryProvider).removeItem(item.id);
      setState(() => _localItems = null);
      ref.invalidate(albumDetailProvider(widget.albumId));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _addPhotos(Album album) async {
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;
    final l10n = AppLocalizations.of(context);

    List<PhotoLibraryItem> photos;
    try {
      photos = await ref
          .read(photoLibraryServiceProvider)
          .photosForChild(child.id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
      return;
    }

    photos = [
      ...photos.where((p) => p.isFavorite),
      ...photos.where((p) => !p.isFavorite),
    ];

    final existingIds = {
      for (final item in album.items)
        if (item.entityType == EntityTypes.mediaAsset) item.entityId,
    };

    if (!mounted) return;
    final selected = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddPhotosSheet(
        photos: photos,
        existingIds: existingIds,
        title: l10n.albumAddPhotos,
      ),
    );

    if (selected == null || selected.isEmpty || !mounted) return;

    try {
      final repo = ref.read(albumsRepositoryProvider);
      for (final mediaId in selected) {
        await repo.addItem(
          albumId: album.id,
          entityType: EntityTypes.mediaAsset,
          entityId: mediaId,
        );
      }
      setState(() => _localItems = null);
      ref.invalidate(albumDetailProvider(widget.albumId));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _deleteAlbum(Album album) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAlbumTitle),
        content: Text(l10n.deleteAlbumMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(albumsRepositoryProvider).softDelete(album.id);
      ref.invalidate(customAlbumsProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}

class _AlbumItemThumb extends ConsumerWidget {
  const _AlbumItemThumb({required this.mediaId});

  final String mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<File?>(
      future: _resolve(ref),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48,
            height: 48,
            child: file == null || !file.existsSync()
                ? ColoredBox(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Image.file(file, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Future<File?> _resolve(WidgetRef ref) async {
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return null;
    final photos = await ref
        .read(photoLibraryServiceProvider)
        .photosForChild(child.id);
    PhotoLibraryItem? match;
    for (final p in photos) {
      if (p.media.id == mediaId) {
        match = p;
        break;
      }
    }
    if (match == null) return null;
    final path = match.media.thumbnailPath ?? match.media.localPath;
    return ref.read(fileStorageServiceProvider).absoluteFile(path);
  }
}

class _AddPhotosSheet extends StatefulWidget {
  const _AddPhotosSheet({
    required this.photos,
    required this.existingIds,
    required this.title,
  });

  final List<PhotoLibraryItem> photos;
  final Set<String> existingIds;
  final String title;

  @override
  State<_AddPhotosSheet> createState() => _AddPhotosSheetState();
}

class _AddPhotosSheetState extends State<_AddPhotosSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final available = widget.photos
        .where((p) => !widget.existingIds.contains(p.media.id))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => Navigator.pop(context, _selected),
                    child: Text(l10n.commonSave),
                  ),
                ],
              ),
            ),
            Expanded(
              child: available.isEmpty
                  ? Center(child: Text(l10n.photosEmpty))
                  : GridView.builder(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final photo = available[index];
                        final id = photo.media.id;
                        final selected = _selected.contains(id);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selected.remove(id);
                              } else {
                                _selected.add(id);
                              }
                            });
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _SheetPhotoTile(item: photo),
                              if (selected)
                                Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.35),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              if (photo.isFavorite)
                                const Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    Icons.favorite,
                                    size: 14,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _SheetPhotoTile extends ConsumerWidget {
  const _SheetPhotoTile({required this.item});

  final PhotoLibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.media.thumbnailPath ?? item.media.localPath;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FutureBuilder<File>(
        future: ref.read(fileStorageServiceProvider).absoluteFile(path),
        builder: (context, snapshot) {
          final file = snapshot.data;
          if (file == null || !file.existsSync()) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_outlined),
            );
          }
          return Image.file(file, fit: BoxFit.cover);
        },
      ),
    );
  }
}
