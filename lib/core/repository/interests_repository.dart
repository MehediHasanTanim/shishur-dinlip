import 'package:shishur_dinlipi/core/domain/models/interest.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/interest_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class InterestsRepository implements Repository {
  Future<List<Interest>> forChild(String childId, {int? limit});
  Future<Interest?> getById(String id);
  Future<Interest> save(Interest interest);
  Future<void> softDelete(String id);
}

class DriftInterestsRepository extends RepositoryBase
    implements InterestsRepository {
  DriftInterestsRepository(super.db);

  @override
  Future<List<Interest>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.interestsDao.forChild(childId, limit: limit);
      return rows.map(InterestMapper.toDomain).toList();
    }, operation: 'interests.forChild');
  }

  @override
  Future<Interest?> getById(String id) {
    return guard(() async {
      final row = await db.interestsDao.getById(id);
      return row == null ? null : InterestMapper.toDomain(row);
    }, operation: 'interests.getById');
  }

  @override
  Future<Interest> save(Interest interest) {
    return guard(() async {
      if (interest.name.trim().isEmpty) {
        throw const ValidationFailure(message: 'Interest name is required.');
      }
      final level = interest.interestLevel;
      if (level != null && (level < 1 || level > 5)) {
        throw const ValidationFailure(
          message: 'Interest level must be between 1 and 5.',
        );
      }
      final nowUtc = now();
      final id = interest.id.isEmpty ? ids.next() : interest.id;
      final existing = await db.interestsDao.getById(id);
      final toSave = interest.copyWith(
        id: id,
        name: interest.name.trim(),
        notes: interest.notes?.trim(),
        clearNotes: interest.notes?.trim().isEmpty ?? true,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.interestsDao.upsert(InterestMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'interests.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.interestsDao.softDelete(id, now());
    }, operation: 'interests.softDelete');
  }
}
