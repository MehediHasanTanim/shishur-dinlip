import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

/// Generates and persists the SQLite encryption passphrase in secure storage.
class DbEncryptionKeyStore {
  DbEncryptionKeyStore(this._secure);

  final SecureStorageService _secure;

  /// Returns existing key or creates a new 32-byte random key (base64).
  Future<String> getOrCreateKey() async {
    final existing = await _secure.read(SecureStorageKeys.dbEncryptionKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final key = _generateKey();
    await _secure.write(key: SecureStorageKeys.dbEncryptionKey, value: key);
    return key;
  }

  Future<String?> readKey() => _secure.read(SecureStorageKeys.dbEncryptionKey);

  Future<bool> isEncryptionMarkedEnabled() {
    return _secure.readBool(SecureStorageKeys.dbEncryptionEnabled);
  }

  Future<void> markEncryptionEnabled(bool enabled) {
    return _secure.writeBool(SecureStorageKeys.dbEncryptionEnabled, enabled);
  }

  String _generateKey() {
    final random = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );
    return base64UrlEncode(bytes);
  }
}
