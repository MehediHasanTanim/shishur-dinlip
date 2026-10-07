import 'package:flutter/foundation.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';

@immutable
class PhotoLibraryItem {
  const PhotoLibraryItem({
    required this.media,
    required this.displayDate,
    this.linkedEntityType,
    this.linkedEntityId,
    this.categoryKey = 'other',
    this.fileMissing = false,
  });

  final MediaAsset media;
  final DateTime displayDate;
  final String? linkedEntityType;
  final String? linkedEntityId;
  final String categoryKey;
  final bool fileMissing;

  bool get isFavorite => media.isFavorite;
}

enum PhotoLibraryGroupBy { all, favorites, year, age, category }
