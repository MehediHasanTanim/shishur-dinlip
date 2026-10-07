/// Typed failures for domain and UI mapping.
sealed class AppFailure implements Exception {
  const AppFailure({this.message, this.cause});

  final String? message;
  final Object? cause;

  @override
  String toString() => message ?? runtimeType.toString();
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure({super.message, super.cause});
}

final class FileFailure extends AppFailure {
  const FileFailure({super.message, super.cause});
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    super.message,
    super.cause,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}

final class PermissionFailure extends AppFailure {
  const PermissionFailure({super.message, super.cause});
}

final class BackupFailure extends AppFailure {
  const BackupFailure({super.message, super.cause});
}

final class RestoreFailure extends AppFailure {
  const RestoreFailure({super.message, super.cause});
}

final class PdfGenerationFailure extends AppFailure {
  const PdfGenerationFailure({super.message, super.cause});
}

final class SecurityFailure extends AppFailure {
  const SecurityFailure({super.message, super.cause, this.lockedOut = false});

  final bool lockedOut;
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.message, super.cause});
}
