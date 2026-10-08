import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/repository/birthdays_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/favorites_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late DriftBirthdaysRepository birthdays;
  late DriftFavoritesRepository favorites;
  late String childId;

  setUp(() async {
    AppConfig.initialize(AppFlavor.dev);
    db = AppDatabase.memory();
    birthdays = DriftBirthdaysRepository(db);
    favorites = DriftFavoritesRepository(db);
    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2019, 3, 15),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
  });

  tearDown(() async {
    await db.close();
  });

  test('schema version is 11 with birthday tables', () async {
    expect(AppDatabase.currentSchemaVersion, 11);
    await db.customSelect('SELECT COUNT(*) AS c FROM birthdays').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM birthday_answers').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM favorites').getSingle();
  });

  test('birthday interview syncs favorites and compare by age', () async {
    final now = DateTime.now().toUtc();
    final b5 = await birthdays.save(
      Birthday(
        id: idGenerator.next(),
        childId: childId,
        age: 5,
        birthdayDate: DateTime(2024, 3, 15),
        theme: 'Dinosaurs',
        favoriteGift: 'Bike',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await birthdays.saveInterviewAnswers(
      birthdayId: b5.id,
      answersByQuestion: {
        BirthdayInterviewQuestions.favoriteFood: 'Mango',
        BirthdayInterviewQuestions.favoriteColor: 'Blue',
        BirthdayInterviewQuestions.favoriteFriend: 'Rafi',
      },
    );

    final b6 = await birthdays.save(
      Birthday(
        id: idGenerator.next(),
        childId: childId,
        age: 6,
        birthdayDate: DateTime(2025, 3, 15),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await birthdays.saveInterviewAnswers(
      birthdayId: b6.id,
      answersByQuestion: {
        BirthdayInterviewQuestions.favoriteFood: 'Pasta',
        BirthdayInterviewQuestions.favoriteColor: 'Green',
      },
    );

    final currentFood = await favorites.currentForCategory(
      childId,
      FavoriteCategories.food,
    );
    expect(currentFood?.value, 'Pasta');

    final foodHistory = await favorites.forChild(
      childId,
      category: FavoriteCategories.food,
    );
    expect(foodHistory.length, 2);

    final compare = await birthdays.compareAnswersByAge(childId);
    final foodRow = compare.firstWhere(
      (c) => c.questionKey == BirthdayInterviewQuestions.favoriteFood,
    );
    expect(foodRow.byAge[5], 'Mango');
    expect(foodRow.byAge[6], 'Pasta');

    final album = await birthdays.ensureBirthdayAlbum(b5, childName: 'Azwad');
    expect(album.albumType, AlbumTypes.birthday);
    expect(album.title, contains('Age 5'));
    final again = await birthdays.getById(b5.id);
    expect(again?.albumId, album.id);
  });

  test('manual favorite save closes previous current', () async {
    final now = DateTime.now().toUtc();
    await favorites.save(
      Favorite(
        id: idGenerator.next(),
        childId: childId,
        category: FavoriteCategories.book,
        value: 'The Gruffalo',
        startDate: DateTime(2023, 1, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await favorites.save(
      Favorite(
        id: idGenerator.next(),
        childId: childId,
        category: FavoriteCategories.book,
        value: 'Matilda',
        startDate: DateTime(2024, 6, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    final current = await favorites.currentForCategory(
      childId,
      FavoriteCategories.book,
    );
    expect(current?.value, 'Matilda');
    final all = await favorites.forChild(
      childId,
      category: FavoriteCategories.book,
    );
    expect(all.where((f) => f.isCurrent).length, 1);
    expect(all.where((f) => !f.isCurrent).single.value, 'The Gruffalo');
  });
}
