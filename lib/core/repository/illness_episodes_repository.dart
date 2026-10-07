import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/mappers/illness_episode_mapper.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

abstract interface class IllnessEpisodesRepository implements Repository {
  Future<List<IllnessEpisode>> forChild(String childId, {int? limit});
  Future<IllnessEpisode?> latestForChild(String childId);
  Future<IllnessEpisode?> getById(String id);
  Future<IllnessEpisode> save({
    required IllnessEpisode episode,
    List<AttachmentDraft> attachments = const [],
  });
  Future<void> softDelete(String id);
}

class DriftIllnessEpisodesRepository extends RepositoryBase
    implements IllnessEpisodesRepository {
  DriftIllnessEpisodesRepository(super.db, {required this.attachments});

  final AttachmentRepository attachments;

  @override
  Future<List<IllnessEpisode>> forChild(String childId, {int? limit}) {
    return guard(() async {
      final rows = await db.illnessEpisodesDao.forChild(childId, limit: limit);
      return rows.map(IllnessEpisodeMapper.toDomain).toList();
    }, operation: 'illness.forChild');
  }

  @override
  Future<IllnessEpisode?> latestForChild(String childId) {
    return guard(() async {
      final row = await db.illnessEpisodesDao.latestForChild(childId);
      return row == null ? null : IllnessEpisodeMapper.toDomain(row);
    }, operation: 'illness.latest');
  }

  @override
  Future<IllnessEpisode?> getById(String id) {
    return guard(() async {
      final row = await db.illnessEpisodesDao.getById(id);
      return row == null ? null : IllnessEpisodeMapper.toDomain(row);
    }, operation: 'illness.getById');
  }

  @override
  Future<IllnessEpisode> save({
    required IllnessEpisode episode,
    List<AttachmentDraft> attachments = const [],
  }) {
    return guard(() async {
      if (episode.title.trim().isEmpty) {
        throw const ValidationFailure(message: 'Illness title is required.');
      }
      if (episode.endDate != null &&
          episode.endDate!.isBefore(
            DateTime(
              episode.startDate.year,
              episode.startDate.month,
              episode.startDate.day,
            ),
          )) {
        throw const ValidationFailure(
          message: 'End date cannot be before start date.',
        );
      }
      final nowUtc = now();
      final id = episode.id.isEmpty ? ids.next() : episode.id;
      final existing = await db.illnessEpisodesDao.getById(id);
      DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
      final toSave = episode.copyWith(
        id: id,
        title: episode.title.trim(),
        startDate: dayOnly(episode.startDate),
        endDate: episode.endDate == null ? null : dayOnly(episode.endDate!),
        clearEndDate: episode.endDate == null,
        diagnosis: _trimOrNull(episode.diagnosis),
        clearDiagnosis: _trimOrNull(episode.diagnosis) == null,
        recoveryNote: _trimOrNull(episode.recoveryNote),
        clearRecoveryNote: _trimOrNull(episode.recoveryNote) == null,
        notes: _trimOrNull(episode.notes),
        clearNotes: _trimOrNull(episode.notes) == null,
        doctorVisitId: _trimOrNull(episode.doctorVisitId),
        clearDoctorVisitId: _trimOrNull(episode.doctorVisitId) == null,
        createdAt: existing?.createdAt ?? nowUtc,
        updatedAt: nowUtc,
      );

      await db.runInTransaction(() async {
        await db.illnessEpisodesDao.upsert(
          IllnessEpisodeMapper.toCompanion(toSave),
        );
        await this.attachments.syncForEntity(
          entityType: EntityTypes.illnessEpisode,
          entityId: id,
          childId: toSave.childId,
          drafts: attachments,
        );
      });
      return toSave;
    }, operation: 'illness.save');
  }

  @override
  Future<void> softDelete(String id) {
    return guard(() async {
      await db.runInTransaction(() async {
        await db.illnessEpisodesDao.softDelete(id, now());
        await attachments.softDeleteForEntity(
          entityType: EntityTypes.illnessEpisode,
          entityId: id,
        );
      });
    }, operation: 'illness.softDelete');
  }

  String? _trimOrNull(String? value) {
    final t = value?.trim();
    if (t == null || t.isEmpty) return null;
    return t;
  }
}
