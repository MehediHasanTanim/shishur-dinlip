// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_words_dao.dart';

// ignore_for_file: type=lint
mixin _$FirstWordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FirstWordsTable get firstWords => attachedDatabase.firstWords;
  FirstWordsDaoManager get managers => FirstWordsDaoManager(this);
}

class FirstWordsDaoManager {
  final _$FirstWordsDaoMixin _db;
  FirstWordsDaoManager(this._db);
  $$FirstWordsTableTableManager get firstWords =>
      $$FirstWordsTableTableManager(_db.attachedDatabase, _db.firstWords);
}
