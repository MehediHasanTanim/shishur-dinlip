import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';

abstract final class AlbumMapper {
  static Album toDomain(AlbumRow row, {List<AlbumItem> items = const []}) {
    return Album(
      id: row.id,
      childId: row.childId,
      albumType: row.albumType,
      title: row.title,
      startDate: row.startDate,
      endDate: row.endDate,
      coverAssetId: row.coverAssetId,
      theme: row.theme,
      languageCode: row.languageCode,
      items: items,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static AlbumsCompanion toCompanion(Album album) {
    return AlbumsCompanion(
      id: Value(album.id),
      childId: Value(album.childId),
      albumType: Value(album.albumType),
      title: Value(album.title),
      startDate: Value(album.startDate),
      endDate: Value(album.endDate),
      coverAssetId: Value(album.coverAssetId),
      theme: Value(album.theme),
      languageCode: Value(album.languageCode),
      createdAt: Value(album.createdAt),
      updatedAt: Value(album.updatedAt),
      deletedAt: Value(album.deletedAt),
    );
  }

  static AlbumItem itemToDomain(AlbumItemRow row) {
    return AlbumItem(
      id: row.id,
      albumId: row.albumId,
      entityType: row.entityType,
      entityId: row.entityId,
      sortOrder: row.sortOrder,
      isIncluded: row.isIncluded,
      customCaption: row.customCaption,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static AlbumItemsCompanion itemToCompanion(AlbumItem item) {
    return AlbumItemsCompanion(
      id: Value(item.id),
      albumId: Value(item.albumId),
      entityType: Value(item.entityType),
      entityId: Value(item.entityId),
      sortOrder: Value(item.sortOrder),
      isIncluded: Value(item.isIncluded),
      customCaption: Value(item.customCaption),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
