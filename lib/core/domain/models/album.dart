import 'package:flutter/foundation.dart';

@immutable
class Album {
  const Album({
    required this.id,
    required this.childId,
    required this.albumType,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.startDate,
    this.endDate,
    this.coverAssetId,
    this.theme,
    this.languageCode,
    this.items = const [],
    this.deletedAt,
  });

  final String id;
  final String childId;
  final String albumType;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? coverAssetId;
  final String? theme;
  final String? languageCode;
  final List<AlbumItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Album copyWith({
    String? id,
    String? childId,
    String? albumType,
    String? title,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? coverAssetId,
    bool clearCoverAssetId = false,
    String? theme,
    bool clearTheme = false,
    String? languageCode,
    bool clearLanguageCode = false,
    List<AlbumItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Album(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      albumType: albumType ?? this.albumType,
      title: title ?? this.title,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      coverAssetId: clearCoverAssetId
          ? null
          : (coverAssetId ?? this.coverAssetId),
      theme: clearTheme ? null : (theme ?? this.theme),
      languageCode: clearLanguageCode
          ? null
          : (languageCode ?? this.languageCode),
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}

@immutable
class AlbumItem {
  const AlbumItem({
    required this.id,
    required this.albumId,
    required this.entityType,
    required this.entityId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.isIncluded = true,
    this.customCaption,
    this.deletedAt,
  });

  final String id;
  final String albumId;
  final String entityType;
  final String entityId;
  final int sortOrder;
  final bool isIncluded;
  final String? customCaption;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}

abstract final class AlbumTypes {
  static const custom = 'custom';
  static const yearInReview = 'year_in_review';
  static const favorites = 'favorites';

  static const all = [custom, yearInReview, favorites];
}

abstract final class AlbumThemes {
  static const minimal = 'minimal';
  static const playful = 'playful';
  static const colorful = 'colorful';
  static const elegant = 'elegant';

  static const all = [minimal, playful, colorful, elegant];
}
