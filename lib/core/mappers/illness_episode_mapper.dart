import 'package:drift/drift.dart';
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/illness_episode.dart';

abstract final class IllnessEpisodeMapper {
  static IllnessEpisode toDomain(IllnessEpisodeRow row) {
    return IllnessEpisode(
      id: row.id,
      childId: row.childId,
      title: row.title,
      startDate: row.startDate,
      endDate: row.endDate,
      symptoms: IllnessEpisode.decodeSymptoms(row.symptomsJson),
      maxTemperatureC: row.maxTemperatureC,
      diagnosis: row.diagnosis,
      doctorVisitId: row.doctorVisitId,
      recoveryNote: row.recoveryNote,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
    );
  }

  static IllnessEpisodesCompanion toCompanion(IllnessEpisode item) {
    return IllnessEpisodesCompanion(
      id: Value(item.id),
      childId: Value(item.childId),
      title: Value(item.title),
      startDate: Value(item.startDate),
      endDate: Value(item.endDate),
      symptomsJson: Value(IllnessEpisode.encodeSymptoms(item.symptoms)),
      maxTemperatureC: Value(item.maxTemperatureC),
      diagnosis: Value(item.diagnosis),
      doctorVisitId: Value(item.doctorVisitId),
      recoveryNote: Value(item.recoveryNote),
      notes: Value(item.notes),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      deletedAt: Value(item.deletedAt),
    );
  }
}
