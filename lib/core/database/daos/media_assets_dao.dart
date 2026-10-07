import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/database/tables/attachments_table.dart';
import 'package:shishur_dinlipi/core/database/tables/media_assets_table.dart';

part 'media_assets_dao.g.dart';

@DriftAccessor(tables: [MediaAssets, Attachments])
class MediaAssetsDao extends DatabaseAccessor<AppDatabase>
    with _$MediaAssetsDaoMixin {
  MediaAssetsDao(super.db);

  Future<MediaAssetRow?> getById(String id) {
    return (select(
      mediaAssets,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }

  Future<List<MediaAssetRow>> getActiveForChild(String childId) {
    return (select(mediaAssets)
          ..where((t) => t.childId.equals(childId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.importedAt)]))
        .get();
  }

  Future<void> upsert(MediaAssetsCompanion companion) {
    return into(mediaAssets).insertOnConflictUpdate(companion);
  }

  Future<void> softDelete(String id, DateTime deletedAt) {
    return (update(mediaAssets)..where((t) => t.id.equals(id))).write(
      MediaAssetsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ),
    );
  }

  Future<int> countActiveAttachments(String mediaAssetId) async {
    final query = selectOnly(attachments)
      ..addColumns([attachments.id.count()])
      ..where(
        attachments.mediaAssetId.equals(mediaAssetId) &
            attachments.deletedAt.isNull(),
      );
    final row = await query.getSingle();
    return row.read(attachments.id.count()) ?? 0;
  }

  Future<List<MediaAssetRow>> getSoftDeleted() {
    return (select(mediaAssets)..where((t) => t.deletedAt.isNotNull())).get();
  }
}
