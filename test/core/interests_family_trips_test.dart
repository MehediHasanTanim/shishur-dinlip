import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/family_event.dart';
import 'package:shishur_dinlipi/core/domain/models/interest.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/repository/family_events_repository.dart';
import 'package:shishur_dinlipi/core/repository/interests_repository.dart';
import 'package:shishur_dinlipi/core/repository/trips_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late String childId;
  late DriftInterestsRepository interests;
  late DriftFamilyEventsRepository familyEvents;
  late DriftTripsRepository trips;

  setUp(() async {
    AppConfig.initialize(AppFlavor.dev);
    db = AppDatabase.memory();
    interests = DriftInterestsRepository(db);
    familyEvents = DriftFamilyEventsRepository(db);
    trips = DriftTripsRepository(db);
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

  test('schema version is 11 with life tables', () async {
    expect(AppDatabase.currentSchemaVersion, 12);
    await db.customSelect('SELECT COUNT(*) AS c FROM interests').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM family_events').getSingle();
    await db.customSelect('SELECT COUNT(*) AS c FROM trips').getSingle();
  });

  test('interest level validation and CRUD', () async {
    final now = DateTime.now().toUtc();
    final saved = await interests.save(
      Interest(
        id: idGenerator.next(),
        childId: childId,
        name: 'LEGO',
        firstNoticed: DateTime(2023, 5, 1),
        interestLevel: 5,
        notes: 'Builds every evening',
        createdAt: now,
        updatedAt: now,
      ),
    );
    expect(saved.name, 'LEGO');
    expect((await interests.forChild(childId)).length, 1);

    await expectLater(
      interests.save(
        Interest(
          id: idGenerator.next(),
          childId: childId,
          name: 'Bad',
          interestLevel: 9,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('family event and trip album templates', () async {
    final now = DateTime.now().toUtc();
    final eid = await familyEvents.save(
      FamilyEvent(
        id: idGenerator.next(),
        childId: childId,
        eventType: FamilyEventTypes.eid,
        title: 'Eid 2024',
        eventDate: DateTime(2024, 4, 10),
        locationText: 'Dhaka',
        story: 'New clothes and sweets',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final album = await familyEvents.ensureFamilyEventAlbum(
      eid,
      childName: 'Azwad',
    );
    expect(album.albumType, AlbumTypes.familyEvent);
    expect((await familyEvents.getById(eid.id))?.albumId, album.id);

    final flight = await trips.save(
      Trip(
        id: idGenerator.next(),
        childId: childId,
        tripType: TripTypes.firstFlight,
        title: 'First flight to Cox’s Bazar',
        placeName: 'Cox’s Bazar',
        startDate: DateTime(2024, 12, 20),
        childReaction: 'Loved the clouds',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final tripAlbum = await trips.ensureTripAlbum(flight, childName: 'Azwad');
    expect(tripAlbum.albumType, AlbumTypes.trip);
    expect((await trips.forChild(childId, tripType: TripTypes.firstFlight)).length, 1);
  });
}
