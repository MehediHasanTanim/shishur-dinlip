// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birthdays_dao.dart';

// ignore_for_file: type=lint
mixin _$BirthdaysDaoMixin on DatabaseAccessor<AppDatabase> {
  $BirthdaysTable get birthdays => attachedDatabase.birthdays;
  $BirthdayAnswersTable get birthdayAnswers => attachedDatabase.birthdayAnswers;
  BirthdaysDaoManager get managers => BirthdaysDaoManager(this);
}

class BirthdaysDaoManager {
  final _$BirthdaysDaoMixin _db;
  BirthdaysDaoManager(this._db);
  $$BirthdaysTableTableManager get birthdays =>
      $$BirthdaysTableTableManager(_db.attachedDatabase, _db.birthdays);
  $$BirthdayAnswersTableTableManager get birthdayAnswers =>
      $$BirthdayAnswersTableTableManager(
        _db.attachedDatabase,
        _db.birthdayAnswers,
      );
}
