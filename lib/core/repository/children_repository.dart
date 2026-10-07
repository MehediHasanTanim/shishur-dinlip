import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/mappers/child_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class ChildrenRepository implements Repository {
  Future<List<Child>> getChildren();
  Future<Child?> getById(String id);
  Future<Child> save(Child child);
  Future<void> softDelete(String id);
}

class DriftChildrenRepository extends RepositoryBase
    implements ChildrenRepository {
  DriftChildrenRepository(super.db);

  @override
  Future<List<Child>> getChildren() {
    return guard(() async {
      final rows = await db.childrenDao.getActive();
      return rows.map(ChildMapper.toDomain).toList();
    }, operation: 'children.getAll');
  }

  @override
  Future<Child?> getById(String id) {
    return guard(() async {
      final row = await db.childrenDao.getById(id);
      return row == null ? null : ChildMapper.toDomain(row);
    }, operation: 'children.getById');
  }

  @override
  Future<Child> save(Child child) {
    return guard(() async {
      final nowUtc = now();
      final toSave = Child(
        id: child.id.isEmpty ? ids.next() : child.id,
        name: child.name,
        nickname: child.nickname,
        dateOfBirth: child.dateOfBirth,
        gender: child.gender,
        bloodGroup: child.bloodGroup,
        birthWeightKg: child.birthWeightKg,
        birthHeightCm: child.birthHeightCm,
        birthplace: child.birthplace,
        schoolName: child.schoolName,
        className: child.className,
        profilePhotoId: child.profilePhotoId,
        notes: child.notes,
        createdAt: child.createdAt,
        updatedAt: nowUtc,
        deletedAt: child.deletedAt,
      );
      // Preserve createdAt on insert.
      final existing = await db.childrenDao.getById(toSave.id);
      final withCreated = existing == null
          ? toSave.copyWith(createdAt: nowUtc, updatedAt: nowUtc)
          : toSave.copyWith(createdAt: existing.createdAt);

      await db.childrenDao.upsert(ChildMapper.toCompanion(withCreated));
      return withCreated;
    }, operation: 'children.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.childrenDao.softDelete(id, now());
    }, operation: 'children.softDelete');
  }
}
