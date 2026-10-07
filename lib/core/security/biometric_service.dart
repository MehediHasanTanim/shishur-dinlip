import 'package:local_auth/local_auth.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';
import 'package:shishur_dinlipi/core/security/pin_service.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

/// Biometric unlock with PIN fallback and device enrollment change detection.
class BiometricService {
  BiometricService(
    this._secure, {
    LocalAuthentication? localAuth,
    AppLogger? logger,
  }) : _localAuth = localAuth ?? LocalAuthentication(),
       _logger = logger ?? AppLogger.instance;

  final SecureStorageService _secure;
  final LocalAuthentication _localAuth;
  final AppLogger _logger;

  Future<bool> isEnabled() =>
      _secure.readBool(SecureStorageKeys.biometricsEnabled);

  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported() &&
          await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> availableTypes() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return const [];
    }
  }

  /// Enables biometrics after verifying PIN (required).
  Future<void> enable({
    required PinService pinService,
    required String currentPin,
  }) async {
    final pinOk = await pinService.verifyPin(currentPin);
    if (!pinOk) {
      throw const SecurityFailure(message: 'PIN verification failed.');
    }
    final supported = await isDeviceSupported();
    if (!supported) {
      throw const SecurityFailure(
        message: 'Biometrics are not available on this device.',
      );
    }
    final types = await availableTypes();
    if (types.isEmpty) {
      throw const SecurityFailure(
        message:
            'No biometrics enrolled. Add Face ID / fingerprint in system settings.',
      );
    }
    final ok = await authenticate(
      reason: 'Enable biometric unlock for Shishur Dinlipi',
    );
    if (!ok) {
      throw const SecurityFailure(message: 'Biometric verification failed.');
    }
    await _secure.writeBool(SecureStorageKeys.biometricsEnabled, true);
    await _secure.write(
      key: SecureStorageKeys.biometricIntegrity,
      value: _integrityToken(types),
    );
  }

  Future<void> disable({
    required PinService pinService,
    required String currentPin,
  }) async {
    final pinOk = await pinService.verifyPin(currentPin);
    if (!pinOk) {
      throw const SecurityFailure(message: 'PIN verification failed.');
    }
    await _secure.writeBool(SecureStorageKeys.biometricsEnabled, false);
    await _secure.delete(SecureStorageKeys.biometricIntegrity);
  }

  /// Returns true on success. On enrollment change, disables biometrics and
  /// throws so UI can fall back to PIN.
  Future<bool> authenticate({required String reason}) async {
    try {
      final types = await availableTypes();
      final stored = await _secure.read(SecureStorageKeys.biometricIntegrity);
      if (stored != null && stored != _integrityToken(types)) {
        await _secure.writeBool(SecureStorageKeys.biometricsEnabled, false);
        throw const SecurityFailure(
          message:
              'Biometrics changed on this device. Please unlock with your PIN.',
        );
      }

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on SecurityFailure {
      rethrow;
    } catch (error, stackTrace) {
      _logger.warn('Biometric auth failed', {
        'errorType': error.runtimeType.toString(),
      });
      _logger.debug('Biometric stack', {'stack': stackTrace.toString()});
      return false;
    }
  }

  String _integrityToken(List<BiometricType> types) {
    final names = types.map((t) => t.name).toList()..sort();
    return names.join('|');
  }
}
