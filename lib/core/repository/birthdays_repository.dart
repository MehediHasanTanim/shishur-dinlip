import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/album_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/birthday_mapper.dart';
import 'package:shishur_dinlipi/core/mappers/favorite_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class BirthdaysRepository implements Repository {
  Future<List<Birthday>> forChild(String childId, {bool includeAnswers = true});
  Future<Birthday?> getById(String id, {bool includeAnswers = true});
  Future<Birthday> save(Birthday birthday);
  Future<void> softDelete(String id);
  Future<Birthday> saveInterviewAnswers({
    required String birthdayId,
    required Map<String, String> answersByQuestion,
  });
  Future<List<BirthdayAnswerComparison>> compareAnswersByAge(String childId);
  Future<Album> ensureBirthdayAlbum(Birthday birthday, {String? childName});
}

class DriftBirthdaysRepository extends RepositoryBase
    implements BirthdaysRepository {
  DriftBirthdaysRepository(super.db);

  @override
  Future<List<Birthday>> forChild(
    String childId, {
    bool includeAnswers = true,
  }) {
    return guard(() async {
      final rows = await db.birthdaysDao.forChild(childId);
      final result = <Birthday>[];
      for (final row in rows) {
        final answers = includeAnswers
            ? (await db.birthdaysDao.answersForBirthday(row.id))
                  .map(BirthdayMapper.answerToDomain)
                  .toList()
            : const <BirthdayAnswer>[];
        result.add(BirthdayMapper.toDomain(row, answers: answers));
      }
      return result;
    }, operation: 'birthdays.forChild');
  }

  @override
  Future<Birthday?> getById(String id, {bool includeAnswers = true}) {
    return guard(() async {
      final row = await db.birthdaysDao.getById(id);
      if (row == null) return null;
      final answers = includeAnswers
          ? (await db.birthdaysDao.answersForBirthday(id))
                .map(BirthdayMapper.answerToDomain)
                .toList()
          : const <BirthdayAnswer>[];
      return BirthdayMapper.toDomain(row, answers: answers);
    }, operation: 'birthdays.getById');
  }

  @override
  Future<Birthday> save(Birthday birthday) {
    return guard(() async {
      if (birthday.age < 0 || birthday.age > 25) {
        throw const ValidationFailure(message: 'Age must be between 0 and 25.');
      }
      final nowUtc = now();
      final id = birthday.id.isEmpty ? ids.next() : birthday.id;
      final existing = await db.birthdaysDao.getById(id);
      final clash = await db.birthdaysDao.forChildAge(
        birthday.childId,
        birthday.age,
      );
      if (clash != null && clash.id != id) {
        throw ValidationFailure(
          message: 'A birthday record for age ${birthday.age} already exists.',
        );
      }
      final toSave = birthday.copyWith(
        id: id,
        locationText: birthday.locationText?.trim(),
        clearLocationText: birthday.locationText?.trim().isEmpty ?? true,
        theme: birthday.theme?.trim(),
        clearTheme: birthday.theme?.trim().isEmpty ?? true,
        favoriteGift: birthday.favoriteGift?.trim(),
        clearFavoriteGift: birthday.favoriteGift?.trim().isEmpty ?? true,
        guestsText: birthday.guestsText?.trim(),
        clearGuestsText: birthday.guestsText?.trim().isEmpty ?? true,
        parentMessage: birthday.parentMessage?.trim(),
        clearParentMessage: birthday.parentMessage?.trim().isEmpty ?? true,
        notes: birthday.notes?.trim(),
        clearNotes: birthday.notes?.trim().isEmpty ?? true,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.birthdaysDao.upsert(BirthdayMapper.toCompanion(toSave));
      return (await getById(id))!;
    }, operation: 'birthdays.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      final deletedAt = now();
      await db.runInTransaction(() async {
        await db.birthdaysDao.softDelete(id, deletedAt);
        await db.birthdaysDao.softDeleteAnswersForBirthday(id, deletedAt);
      });
    }, operation: 'birthdays.softDelete');
  }

  @override
  Future<Birthday> saveInterviewAnswers({
    required String birthdayId,
    required Map<String, String> answersByQuestion,
  }) {
    return guard(() async {
      final birthday = await getById(birthdayId, includeAnswers: true);
      if (birthday == null) {
        throw const ValidationFailure(message: 'Birthday not found.');
      }
      final nowUtc = now();
      final existingByKey = {
        for (final a in birthday.answers) a.questionKey: a,
      };

      await db.runInTransaction(() async {
        var order = 0;
        for (final key in BirthdayInterviewQuestions.ordered) {
          final text = (answersByQuestion[key] ?? '').trim();
          final existing = existingByKey[key];
          if (text.isEmpty) {
            if (existing != null) {
              await db.birthdaysDao.softDeleteAnswer(existing.id, nowUtc);
            }
            continue;
          }
          final answer = BirthdayAnswer(
            id: existing?.id ?? ids.next(),
            birthdayId: birthdayId,
            questionKey: key,
            answer: text,
            sortOrder: order++,
            createdAt: existing?.createdAt ?? nowUtc,
            updatedAt: nowUtc,
          );
          await db.birthdaysDao.upsertAnswer(
            BirthdayMapper.answerToCompanion(answer),
          );

          final category =
              BirthdayInterviewQuestions.favoriteCategoryByQuestion[key];
          if (category != null) {
            await _syncFavoriteFromInterview(
              childId: birthday.childId,
              category: category,
              value: text,
              age: birthday.age,
              birthdayId: birthdayId,
              asOf: birthday.birthdayDate,
              nowUtc: nowUtc,
            );
          }
        }
      });

      return (await getById(birthdayId))!;
    }, operation: 'birthdays.saveInterviewAnswers');
  }

  Future<void> _syncFavoriteFromInterview({
    required String childId,
    required String category,
    required String value,
    required int age,
    required String birthdayId,
    required DateTime asOf,
    required DateTime nowUtc,
  }) async {
    final current = await db.favoritesDao.currentForCategory(childId, category);
    if (current != null &&
        current.value.trim().toLowerCase() == value.trim().toLowerCase()) {
      return;
    }
    if (current != null) {
      await db.favoritesDao.upsert(
        FavoriteMapper.toCompanion(
          FavoriteMapper.toDomain(current).copyWith(
            endDate: asOf,
            updatedAt: nowUtc,
          ),
        ),
      );
    }
    await db.favoritesDao.upsert(
      FavoriteMapper.toCompanion(
        Favorite(
          id: ids.next(),
          childId: childId,
          category: category,
          value: value.trim(),
          startDate: asOf,
          sourceBirthdayId: birthdayId,
          recordedAge: age,
          createdAt: nowUtc,
          updatedAt: nowUtc,
        ),
      ),
    );
  }

  @override
  Future<List<BirthdayAnswerComparison>> compareAnswersByAge(String childId) {
    return guard(() async {
      final birthdays = await forChild(childId, includeAnswers: true);
      final byQuestion = <String, Map<int, String>>{};
      for (final key in BirthdayInterviewQuestions.ordered) {
        byQuestion[key] = {};
      }
      for (final b in birthdays) {
        for (final a in b.answers) {
          final map = byQuestion.putIfAbsent(a.questionKey, () => {});
          if (a.answer.trim().isNotEmpty) {
            map[b.age] = a.answer.trim();
          }
        }
      }
      return BirthdayInterviewQuestions.ordered
          .map(
            (key) => BirthdayAnswerComparison(
              questionKey: key,
              byAge: Map.unmodifiable(byQuestion[key] ?? const {}),
            ),
          )
          .where((c) => c.byAge.isNotEmpty)
          .toList();
    }, operation: 'birthdays.compareAnswersByAge');
  }

  @override
  Future<Album> ensureBirthdayAlbum(
    Birthday birthday, {
    String? childName,
  }) {
    return guard(() async {
      if (birthday.albumId != null) {
        final existing = await db.albumsDao.getById(birthday.albumId!);
        if (existing != null && existing.deletedAt == null) {
          final items = await db.albumsDao.itemsForAlbum(existing.id);
          return AlbumMapper.toDomain(
            existing,
            items: items.map(AlbumMapper.itemToDomain).toList(),
          );
        }
      }

      final nowUtc = now();
      final albumId = ids.next();
      final name = (childName?.trim().isNotEmpty ?? false)
          ? childName!.trim()
          : 'Birthday';
      final album = Album(
        id: albumId,
        childId: birthday.childId,
        albumType: AlbumTypes.birthday,
        title: '$name — Age ${birthday.age}',
        startDate: birthday.birthdayDate,
        endDate: birthday.birthdayDate,
        coverAssetId: birthday.coverAssetId,
        theme: birthday.theme ?? AlbumThemes.playful,
        createdAt: nowUtc,
        updatedAt: nowUtc,
      );
      await db.albumsDao.upsert(AlbumMapper.toCompanion(album));
      await db.birthdaysDao.upsert(
        BirthdayMapper.toCompanion(
          birthday.copyWith(albumId: albumId, updatedAt: nowUtc),
        ),
      );
      return album;
    }, operation: 'birthdays.ensureBirthdayAlbum');
  }
}
