// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'illness_episodes_dao.dart';

// ignore_for_file: type=lint
mixin _$IllnessEpisodesDaoMixin on DatabaseAccessor<AppDatabase> {
  $IllnessEpisodesTable get illnessEpisodes => attachedDatabase.illnessEpisodes;
  IllnessEpisodesDaoManager get managers => IllnessEpisodesDaoManager(this);
}

class IllnessEpisodesDaoManager {
  final _$IllnessEpisodesDaoMixin _db;
  IllnessEpisodesDaoManager(this._db);
  $$IllnessEpisodesTableTableManager get illnessEpisodes =>
      $$IllnessEpisodesTableTableManager(
        _db.attachedDatabase,
        _db.illnessEpisodes,
      );
}
