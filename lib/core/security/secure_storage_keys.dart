/// Keys for [SecureStorageService]. Values must never be logged.
abstract final class SecureStorageKeys {
  static const dbEncryptionKey = 'db_encryption_key_v1';
  static const dbEncryptionEnabled = 'db_encryption_enabled_v1';
  static const pinSalt = 'pin_salt_v1';
  static const pinHash = 'pin_hash_v1';
  static const pinEnabled = 'pin_enabled_v1';
  static const biometricsEnabled = 'biometrics_enabled_v1';
  static const autoLockMode = 'auto_lock_mode_v1';
  static const failedPinAttempts = 'failed_pin_attempts_v1';
  static const pinLockUntil = 'pin_lock_until_v1';
  static const biometricIntegrity = 'biometric_integrity_v1';
}
