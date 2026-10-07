import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';

/// Thin wrapper around platform secure storage (Keychain / Keystore).
///
/// Stores DB encryption keys and PIN metadata — never log values.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage, Map<String, String>? memory})
    : _memory = memory,
      _storage = memory != null
          ? null
          : (storage ??
                const FlutterSecureStorage(
                  aOptions: AndroidOptions(encryptedSharedPreferences: true),
                  iOptions: IOSOptions(
                    accessibility: KeychainAccessibility.first_unlock_this_device,
                  ),
                ));

  /// Test helper — fully in-memory, no platform channels.
  factory SecureStorageService.memory([Map<String, String>? seed]) {
    return SecureStorageService(memory: seed ?? <String, String>{});
  }

  final FlutterSecureStorage? _storage;
  final Map<String, String>? _memory;

  Future<void> write({required String key, required String value}) async {
    final memory = _memory;
    if (memory != null) {
      memory[key] = value;
      return;
    }
    await _storage!.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    final memory = _memory;
    if (memory != null) return memory[key];
    return _storage!.read(key: key);
  }

  Future<void> delete(String key) async {
    final memory = _memory;
    if (memory != null) {
      memory.remove(key);
      return;
    }
    await _storage!.delete(key: key);
  }

  Future<void> deleteAllSecurityKeys() async {
    for (final key in [
      SecureStorageKeys.pinSalt,
      SecureStorageKeys.pinHash,
      SecureStorageKeys.pinEnabled,
      SecureStorageKeys.biometricsEnabled,
      SecureStorageKeys.failedPinAttempts,
      SecureStorageKeys.pinLockUntil,
      SecureStorageKeys.biometricIntegrity,
    ]) {
      await delete(key);
    }
  }

  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final raw = await read(key);
    if (raw == null) return defaultValue;
    return raw == 'true' || raw == '1';
  }

  Future<void> writeBool(String key, bool value) {
    return write(key: key, value: value ? 'true' : 'false');
  }

  Future<int> readInt(String key, {int defaultValue = 0}) async {
    final raw = await read(key);
    return int.tryParse(raw ?? '') ?? defaultValue;
  }

  Future<void> writeInt(String key, int value) {
    return write(key: key, value: '$value');
  }
}
