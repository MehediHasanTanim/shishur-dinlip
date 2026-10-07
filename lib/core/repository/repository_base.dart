import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

/// Shared repository helpers — widgets never call the DB directly.
abstract class RepositoryBase {
  RepositoryBase(this.db, {IdGenerator? ids, AppLogger? logger})
    : ids = ids ?? idGenerator,
      logger = logger ?? AppLogger.instance;

  final AppDatabase db;
  final IdGenerator ids;
  final AppLogger logger;

  DateTime now() => DateTime.now().toUtc();

  Future<T> guard<T>(Future<T> Function() action, {String? operation}) async {
    try {
      return await action();
    } on AppFailure {
      rethrow;
    } catch (error, stackTrace) {
      logger.error(
        'Repository failure',
        error: error,
        stackTrace: stackTrace,
        fields: {'operation': ?operation},
      );
      throw DatabaseFailure(cause: error);
    }
  }
}

/// Marker for feature repository contracts.
abstract interface class Repository {}
