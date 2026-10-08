import 'package:shishur_dinlipi/core/domain/models/first_word.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/first_word_mapper.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class FirstWordsRepository implements Repository {
  Future<List<FirstWord>> forChild(String childId, {int? limit});
  Future<FirstWord?> getById(String id);
  Future<FirstWord> save(FirstWord word);
  Future<void> softDelete(String id);
}

class DriftFirstWordsRepository extends RepositoryBase
    implements FirstWordsRepository {
  DriftFirstWordsRepository(super.db);

  @override
  Future<List<FirstWord>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.firstWordsDao.forChild(childId, limit: limit);
      return rows.map(FirstWordMapper.toDomain).toList();
    }, operation: 'firstWords.forChild');
  }

  @override
  Future<FirstWord?> getById(String id) {
    return guard(() async {
      final row = await db.firstWordsDao.getById(id);
      return row == null ? null : FirstWordMapper.toDomain(row);
    }, operation: 'firstWords.getById');
  }

  @override
  Future<FirstWord> save(FirstWord word) {
    return guard(() async {
      if (word.word.trim().isEmpty) {
        throw const ValidationFailure(message: 'Word is required.');
      }
      final nowUtc = now();
      final id = word.id.isEmpty ? ids.next() : word.id;
      final existing = await db.firstWordsDao.getById(id);
      final normalizedDate = word.datePrecision.normalize(word.eventDate);
      final hasAudio =
          word.audioAssetId != null && word.audioAssetId!.isNotEmpty;
      final toSave = word.copyWith(
        id: id,
        word: word.word.trim(),
        eventDate: normalizedDate,
        clearEventDate: normalizedDate == null,
        audioAssetId: word.audioAssetId,
        clearAudioAssetId: !hasAudio,
        // Real clip ⇒ true; otherwise keep caller's flag (legacy placeholder).
        audioPlaceholder: hasAudio ? true : word.audioPlaceholder,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );
      await db.firstWordsDao.upsert(FirstWordMapper.toCompanion(toSave));
      return toSave;
    }, operation: 'firstWords.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.firstWordsDao.softDelete(id, now());
    }, operation: 'firstWords.softDelete');
  }
}
