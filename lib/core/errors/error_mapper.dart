import 'package:flutter/widgets.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

abstract final class ErrorMapper {
  static AppFailure map(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) return error;
    return UnknownFailure(message: error.toString(), cause: error);
  }

  static String localize(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);
    final failure = map(error);

    return switch (failure) {
      DatabaseFailure() => l10n.errorDatabase,
      FileFailure() => l10n.errorFile,
      ValidationFailure() => failure.message ?? l10n.errorValidation,
      PermissionFailure() => l10n.errorPermission,
      BackupFailure() => l10n.errorBackup,
      RestoreFailure() => l10n.errorRestore,
      PdfGenerationFailure() => l10n.errorPdf,
      UnknownFailure() => l10n.errorGeneric,
    };
  }
}
