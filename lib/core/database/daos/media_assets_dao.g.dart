// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_assets_dao.dart';

// ignore_for_file: type=lint
mixin _$MediaAssetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MediaAssetsTable get mediaAssets => attachedDatabase.mediaAssets;
  $AttachmentsTable get attachments => attachedDatabase.attachments;
  MediaAssetsDaoManager get managers => MediaAssetsDaoManager(this);
}

class MediaAssetsDaoManager {
  final _$MediaAssetsDaoMixin _db;
  MediaAssetsDaoManager(this._db);
  $$MediaAssetsTableTableManager get mediaAssets =>
      $$MediaAssetsTableTableManager(_db.attachedDatabase, _db.mediaAssets);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db.attachedDatabase, _db.attachments);
}
