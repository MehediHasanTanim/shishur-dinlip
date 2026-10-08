import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/repository/allergies_repository.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';

void main() {
  late AppDatabase db;
  late AllergiesRepository allergies;
  late String childId;

  setUp(() async {
    db = AppDatabase.memory();
    allergies = DriftAllergiesRepository(db);
    final now = DateTime.now().toUtc();
    final child = await DriftChildrenRepository(db).save(
      Child(
        id: idGenerator.next(),
        name: 'Azwad',
        dateOfBirth: DateTime(2018, 1, 1),
        createdAt: now,
        updatedAt: now,
      ),
    );
    childId = child.id;
  });

  tearDown(() async {
    await db.close();
  });

  test('create read update delete allergy', () async {
    final now = DateTime.now().toUtc();
    final created = await allergies.save(
      Allergy(
        id: '',
        childId: childId,
        allergen: 'Peanuts',
        allergyType: AllergyTypes.food,
        severity: AllergySeverities.severe,
        reaction: 'Hives',
        doctorConfirmed: true,
        firstObserved: DateTime(2020, 5, 1),
        notes: 'Avoid all nuts',
        createdAt: now,
        updatedAt: now,
      ),
    );

    expect(created.id, isNotEmpty);
    expect(created.allergen, 'Peanuts');
    expect(created.allergyType, AllergyTypes.food);
    expect(created.severity, AllergySeverities.severe);
    expect(created.doctorConfirmed, isTrue);

    final listed = await allergies.forChild(childId);
    expect(listed, hasLength(1));
    expect(listed.first.id, created.id);

    final byId = await allergies.getById(created.id);
    expect(byId?.reaction, 'Hives');

    final updated = await allergies.save(
      created.copyWith(
        allergen: 'Tree nuts',
        severity: AllergySeverities.moderate,
        clearReaction: true,
        notes: 'Updated note',
      ),
    );
    expect(updated.allergen, 'Tree nuts');
    expect(updated.severity, AllergySeverities.moderate);
    expect(updated.reaction, isNull);
    expect(updated.notes, 'Updated note');

    await allergies.softDelete(created.id);
    expect(await allergies.forChild(childId), isEmpty);
    expect(await allergies.getById(created.id), isNull);
  });

  test('empty allergen rejected', () async {
    final now = DateTime.now().toUtc();
    expect(
      () => allergies.save(
        Allergy(
          id: '',
          childId: childId,
          allergen: '  ',
          allergyType: AllergyTypes.unknown,
          severity: AllergySeverities.unknown,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
