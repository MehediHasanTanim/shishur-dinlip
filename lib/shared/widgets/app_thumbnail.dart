import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';

/// Loads local media preferring thumbnails and decode-cache sizing.
class AppThumbnail extends StatefulWidget {
  const AppThumbnail({
    super.key,
    required this.storage,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
  });

  final FileStorageService storage;
  final MediaAsset asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  @override
  State<AppThumbnail> createState() => _AppThumbnailState();
}

class _AppThumbnailState extends State<AppThumbnail> {
  Future<File?>? _future;

  @override
  void initState() {
    super.initState();
    _future = _resolve();
  }

  @override
  void didUpdateWidget(covariant AppThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id ||
        oldWidget.asset.thumbnailPath != widget.asset.thumbnailPath ||
        oldWidget.asset.localPath != widget.asset.localPath) {
      _future = _resolve();
    }
  }

  Future<File?> _resolve() async {
    final isVideo = widget.asset.assetType == MediaAssetType.video;
    // Videos: thumbnailPath only — never decode the video file as an image.
    if (isVideo) {
      final thumb = widget.asset.thumbnailPath;
      if (thumb == null) return null;
      final file = await widget.storage.absoluteFile(thumb);
      return await file.exists() ? file : null;
    }
    final preferred = widget.asset.thumbnailPath ?? widget.asset.localPath;
    final file = await widget.storage.absoluteFile(preferred);
    if (await file.exists()) return file;
    if (widget.asset.thumbnailPath != null) {
      final full = await widget.storage.absoluteFile(widget.asset.localPath);
      if (await full.exists()) return full;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cacheWidth = widget.width == null
        ? 360
        : (widget.width! * MediaQuery.devicePixelRatioOf(context)).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FutureBuilder<File?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            final file = snapshot.data;
            if (file == null) {
              return ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }
            return Image.file(
              file,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
              cacheWidth: cacheWidth,
              filterQuality: FilterQuality.low,
              errorBuilder: (_, _, _) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image_outlined),
              ),
            );
          },
        ),
      ),
    );
  }
}
