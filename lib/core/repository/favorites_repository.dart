import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/favorite_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class FavoritesRepository implements Repository {
  Future<List<Favorite>> forChild(String childId, {String? category});
  Future<Favorite?> getById(String id);
  Future<Favorite?> currentForCategory(String childId, String category);
  Future<Favorite> save(Favorite favorite);
  Future<void> softDelete(String id);
  Future<Map<String, List<Favorite>>> groupedByCategory(String childId);
}

class DriftFavoritesRepository extends RepositoryBase
    implements FavoritesRepository {
  DriftFavoritesRepository(super.db);

  @override
  Future<List<Favorite>> forChild(String childId, {String? category}) {
    return guard(() async {
      final rows = await db.favoritesDao.forChild(
        childId,
        category: category,
      );
      return rows.map(FavoriteMapper.toDomain).toList();
    }, operation: 'favorites.forChild');
  }

  @override
  Future<Favorite?> getById(String id) {
    return guard(() async {
      final row = await db.favoritesDao.getById(id);
      return row == null ? null : FavoriteMapper.toDomain(row);
    }, operation: 'favorites.getById');
  }

  @override
  Future<Favorite?> currentForCategory(String childId, String category) {
    return guard(() async {
      final row = await db.favoritesDao.currentForCategory(childId, category);
      return row == null ? null : FavoriteMapper.toDomain(row);
    }, operation: 'favorites.currentForCategory');
  }

  @override
  Future<Favorite> save(Favorite favorite) {
    return guard(() async {
      if (!FavoriteCategories.all.contains(favorite.category)) {
        throw const ValidationFailure(message: 'Invalid favorite category.');
      }
      if (favorite.value.trim().isEmpty) {
        throw const ValidationFailure(message: 'Favorite value is required.');
      }
      final nowUtc = now();
      final id = favorite.id.isEmpty ? ids.next() : favorite.id;
      final existing = await db.favoritesDao.getById(id);

      // Closing previous current when saving a new current value.
      if (favorite.endDate == null) {
        final current = await db.favoritesDao.currentForCategory(
          favorite.childId,
          favorite.category,
        );
        if (current != null && current.id != id) {
          await db.favoritesDao.upsert(
            FavoriteMapper.toCompanion(
              FavoriteMapper.toDomain(current).copyWith(
                endDate: favorite.startDate ?? nowUtc,
                updatedAt: nowUtc,
              ),
            ),
          );
        }
      }

      final toSave = favorite.copyWith(
        id: id,
        value: favorite.value.trim(),
        notes: favorite.notes?.trim(),
        clearNotes: favorite.notes?.trim().isEmpty ?? true,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.favoritesDao.upsert(FavoriteMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'favorites.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.favoritesDao.softDelete(id, now());
    }, operation: 'favorites.softDelete');
  }

  @override
  Future<Map<String, List<Favorite>>> groupedByCategory(String childId) {
    return guard(() async {
      final all = await forChild(childId);
      final map = <String, List<Favorite>>{
        for (final c in FavoriteCategories.all) c: <Favorite>[],
      };
      for (final f in all) {
        map.putIfAbsent(f.category, () => []).add(f);
      }
      return map;
    }, operation: 'favorites.groupedByCategory');
  }
}
