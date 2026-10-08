import 'package:shishur_dinlipi/core/domain/models/allergy.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/allergy_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class AllergiesRepository implements Repository {
  Future<List<Allergy>> forChild(String childId, {int? limit});
  Future<Allergy?> getById(String id);
  Future<Allergy> save(Allergy allergy);
  Future<void> softDelete(String id);
}

class DriftAllergiesRepository extends RepositoryBase
    implements AllergiesRepository {
  DriftAllergiesRepository(super.db);

  @override
  Future<List<Allergy>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.allergiesDao.forChild(childId, limit: limit);
      return rows.map(AllergyMapper.toDomain).toList();
    }, operation: 'allergies.forChild');
  }

  @override
  Future<Allergy?> getById(String id) {
    return guard(() async {
      final row = await db.allergiesDao.getById(id);
      return row == null ? null : AllergyMapper.toDomain(row);
    }, operation: 'allergies.getById');
  }

  @override
  Future<Allergy> save(Allergy allergy) {
    return guard(() async {
      if (allergy.allergen.trim().isEmpty) {
        throw const ValidationFailure(message: 'Allergen is required.');
      }
      final nowUtc = now();
      final id = allergy.id.isEmpty ? ids.next() : allergy.id;
      final existing = await db.allergiesDao.getById(id);
      final toSave = allergy.copyWith(
        id: id,
        allergen: allergy.allergen.trim(),
        reaction: _trimOrNull(allergy.reaction),
        clearReaction: _trimOrNull(allergy.reaction) == null,
        notes: _trimOrNull(allergy.notes),
        clearNotes: _trimOrNull(allergy.notes) == null,
        firstObserved: allergy.firstObserved == null
            ? null
            : DateTime(
                allergy.firstObserved!.year,
                allergy.firstObserved!.month,
                allergy.firstObserved!.day,
              ),
        clearFirstObserved: allergy.firstObserved == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.allergiesDao.upsert(AllergyMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'allergies.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.allergiesDao.softDelete(id, now());
    }, operation: 'allergies.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
