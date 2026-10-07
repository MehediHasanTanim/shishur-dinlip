import 'package:drift/drift.dart';

@DataClassName('MediaAssetRow')
@TableIndex(name: 'media_assets_child', columns: {#childId})
@TableIndex(name: 'media_assets_checksum', columns: {#checksum})
@TableIndex(name: 'media_assets_favorite', columns: {#isFavorite})
class MediaAssets extends Table {
  TextColumn get id => text()();
  TextColumn get childId => text().nullable()();
  TextColumn get assetType => text()();
  TextColumn get localPath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get mimeType => text()();
  TextColumn get originalFilename => text().nullable()();
  IntColumn get fileSizeBytes => integer()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  DateTimeColumn get capturedAt => dateTime().nullable()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get checksum => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
