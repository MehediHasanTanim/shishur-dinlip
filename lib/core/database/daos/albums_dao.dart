import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/album_items_table.dart';
import 'package:shishur_dinlipi/core/database/tables/albums_table.dart';

part 'albums_dao.g.dart';

@DriftAccessor(tables: [Albums, AlbumItems])
class AlbumsDao extends DatabaseAccessor<AppDatabase> with _$AlbumsDaoMixin {
  AlbumsDao(super.db);

  Future<List<AlbumRow>> forChild(String childId, {String? albumType}) {
    final query = select(albums)
      ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull());
    if (albumType != null) {
      query.where((t) => t.albumType.equals(albumType));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.get();
  }

  Future<AlbumRow?> getById(String id) {
    return (select(albums)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsert(AlbumsCompanion companion) {
    return into(albums).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(albums)..where((t) => t.id.equals(id))).write(
      AlbumsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<List<AlbumItemRow>> itemsForAlbum(String albumId) {
    return (select(albumItems)
          ..where(
            (t) =>
                t.albumId.equals(albumId) &
                t.deletedAt.isNull() &
                t.isIncluded.equals(true),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<AlbumItemRow?> getItemById(String id) {
    return (select(albumItems)..where(
          (t) => t.id.equals(id) & t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<void> upsertItem(AlbumItemsCompanion companion) {
    return into(albumItems).insertOnConflictUpdate(companion);
  }

  Future<void> softDeleteItem(String id, DateTime deletedAt) {
    return (update(albumItems)..where((t) => t.id.equals(id))).write(
      AlbumItemsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
        isIncluded: const Value(false),
      ),
    );
  }

  Future<void> softDeleteItemsForAlbum(String albumId, DateTime deletedAt) {
    return (update(albumItems)
          ..where((t) => t.albumId.equals(albumId) & t.deletedAt.isNull()))
        .write(
          AlbumItemsCompanion(
            deletedAt: Value(deletedAt),
            updatedAt: Value(deletedAt),
            isIncluded: const Value(false),
          ),
        );
  }
}
