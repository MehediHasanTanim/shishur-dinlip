import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/school_profile_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class SchoolProfilesRepository implements Repository {
  Future<List<SchoolProfile>> forChild(String childId);
  Future<SchoolProfile?> getById(String id);
  Future<SchoolProfile?> currentForChild(String childId);
  Future<SchoolProfile> save(SchoolProfile profile);
  Future<void> softDelete(String id);
}

class DriftSchoolProfilesRepository extends RepositoryBase
    implements SchoolProfilesRepository {
  DriftSchoolProfilesRepository(super.db);

  @override
  Future<List<SchoolProfile>> forChild(String childId) {
    return guard(() async {
      final rows = await db.schoolProfilesDao.forChild(childId);
      return rows.map(SchoolProfileMapper.toDomain).toList();
    }, operation: 'schoolProfiles.forChild');
  }

  @override
  Future<SchoolProfile?> getById(String id) {
    return guard(() async {
      final row = await db.schoolProfilesDao.getById(id);
      return row == null ? null : SchoolProfileMapper.toDomain(row);
    }, operation: 'schoolProfiles.getById');
  }

  @override
  Future<SchoolProfile?> currentForChild(String childId) {
    return guard(() async {
      final row = await db.schoolProfilesDao.currentForChild(childId);
      return row == null ? null : SchoolProfileMapper.toDomain(row);
    }, operation: 'schoolProfiles.current');
  }

  @override
  Future<SchoolProfile> save(SchoolProfile profile) {
    return guard(() async {
      if (profile.schoolName.trim().isEmpty) {
        throw const ValidationFailure(message: 'School name is required.');
      }
      if (profile.startDate != null &&
          profile.endDate != null &&
          profile.endDate!.isBefore(profile.startDate!)) {
        throw const ValidationFailure(
          message: 'End date cannot be before start date.',
        );
      }

      final nowUtc = now();
      final id = profile.id.isEmpty ? ids.next() : profile.id;
      final existing = await db.schoolProfilesDao.getById(id);
      final toSave = profile.copyWith(
        id: id,
        schoolName: profile.schoolName.trim(),
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.schoolProfilesDao.upsert(
        SchoolProfileMapper.toCompanion(toSave),
      );
      return toSave;
    }, operation: 'schoolProfiles.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.schoolProfilesDao.softDelete(id, now());
    }, operation: 'schoolProfiles.softDelete');
  }
}
