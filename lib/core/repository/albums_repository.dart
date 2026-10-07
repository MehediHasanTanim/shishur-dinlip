import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/album_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class AlbumsRepository implements Repository {
  Future<List<Album>> forChild(String childId, {String? albumType});
  Future<Album?> getById(String id, {bool includeItems = true});
  Future<Album> save(Album album);
  Future<void> softDelete(String id);
  Future<AlbumItem> addItem({
    required String albumId,
    required String entityType,
    required String entityId,
    String? customCaption,
  });
  Future<void> removeItem(String itemId);
  Future<void> reorderItems(String albumId, List<String> orderedItemIds);
  Future<Album> setCover(String albumId, String? coverAssetId);
}

class DriftAlbumsRepository extends RepositoryBase implements AlbumsRepository {
  DriftAlbumsRepository(super.db);

  @override
  Future<List<Album>> forChild(String childId, {String? albumType}) {
    return guard(() async {
      final rows = await db.albumsDao.forChild(childId, albumType: albumType);
      return rows.map((r) => AlbumMapper.toDomain(r)).toList();
    }, operation: 'albums.forChild');
  }

  @override
  Future<Album?> getById(String id, {bool includeItems = true}) {
    return guard(() async {
      final row = await db.albumsDao.getById(id);
      if (row == null) return null;
      final items = includeItems
          ? (await db.albumsDao.itemsForAlbum(id))
                .map(AlbumMapper.itemToDomain)
                .toList()
          : const <AlbumItem>[];
      return AlbumMapper.toDomain(row, items: items);
    }, operation: 'albums.getById');
  }

  @override
  Future<Album> save(Album album) {
    return guard(() async {
      if (album.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Album title is required.');
      }
      if (!AlbumTypes.all.contains(album.albumType)) {
        throw const ValidationFailure(message: 'Invalid album type.');
      }
      final nowUtc = now();
      final id = album.id.isEmpty ? ids.next() : album.id;
      final existing = await db.albumsDao.getById(id);
      final toSave = album.copyWith(
        id: id,
        title: album.title.trim(),
        theme: album.theme ?? AlbumThemes.minimal,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.albumsDao.upsert(AlbumMapper.toCompanion(toSave));
      return (await getById(id))!;
    }, operation: 'albums.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      final deletedAt = now();
      await db.runInTransaction(() async {
        await db.albumsDao.softDelete(id, deletedAt);
        await db.albumsDao.softDeleteItemsForAlbum(id, deletedAt);
      });
    }, operation: 'albums.softDelete');
  }

  @override
  Future<AlbumItem> addItem({
    required String albumId,
    required String entityType,
    required String entityId,
    String? customCaption,
  }) {
    return guard(() async {
      final album = await db.albumsDao.getById(albumId);
      if (album == null) {
        throw const ValidationFailure(message: 'Album not found.');
      }
      final existing = await db.albumsDao.itemsForAlbum(albumId);
      final duplicate = existing.any(
        (i) => i.entityType == entityType && i.entityId == entityId,
      );
      if (duplicate) {
        return AlbumMapper.itemToDomain(
          existing.firstWhere(
            (i) => i.entityType == entityType && i.entityId == entityId,
          ),
        );
      }
      final nowUtc = now();
      final item = AlbumItem(
        id: ids.next(),
        albumId: albumId,
        entityType: entityType,
        entityId: entityId,
        sortOrder: existing.length,
        customCaption: customCaption?.trim().isEmpty == true
            ? null
            : customCaption?.trim(),
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );
      await db.runInTransaction(() async {
        await db.albumsDao.upsertItem(AlbumMapper.itemToCompanion(item));
        await db.albumsDao.upsert(
          AlbumMapper.toCompanion(
            AlbumMapper.toDomain(album).copyWith(updatedAt: nowUtc),
          ),
        );
      });
      return item;
    }, operation: 'albums.addItem');
  }

  @override
  Future<void> removeItem(String itemId) {
    return guard(() async {
      await db.albumsDao.softDeleteItem(itemId, now());
    }, operation: 'albums.removeItem');
  }

  @override
  Future<void> reorderItems(String albumId, List<String> orderedItemIds) {
    return guard(() async {
      final nowUtc = now();
      await db.runInTransaction(() async {
        for (var i = 0; i < orderedItemIds.length; i++) {
          final existing = await db.albumsDao.getItemById(orderedItemIds[i]);
          if (existing == null || existing.albumId != albumId) continue;
          await db.albumsDao.upsertItem(
            AlbumMapper.itemToCompanion(
              AlbumMapper.itemToDomain(existing).copyWithSort(i, nowUtc),
            ),
          );
        }
        final album = await db.albumsDao.getById(albumId);
        if (album != null) {
          await db.albumsDao.upsert(
            AlbumMapper.toCompanion(
              AlbumMapper.toDomain(album).copyWith(updatedAt: nowUtc),
            ),
          );
        }
      });
    }, operation: 'albums.reorder');
  }

  @override
  Future<Album> setCover(String albumId, String? coverAssetId) {
    return guard(() async {
      final existing = await getById(albumId);
      if (existing == null) {
        throw const ValidationFailure(message: 'Album not found.');
      }
      return save(
        existing.copyWith(
          coverAssetId: coverAssetId,
          clearCoverAssetId: coverAssetId == null,
          updatedAt: now(),
        ),
      );
    }, operation: 'albums.setCover');
  }
}

extension on AlbumItem {
  AlbumItem copyWithSort(int sortOrder, DateTime updatedAt) {
    return AlbumItem(
      id: id,
      albumId: albumId,
      entityType: entityType,
      entityId: entityId,
      sortOrder: sortOrder,
      isIncluded: isIncluded,
      customCaption: customCaption,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
