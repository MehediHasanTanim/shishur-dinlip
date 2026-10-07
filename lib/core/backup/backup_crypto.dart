import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// AES-256-GCM backup encryption with PBKDF2 password-derived keys.
abstract final class BackupCrypto {
  static const magic = 'SDJBACKv';
  static const formatVersion = 1;
  static const saltLength = 16;
  static const nonceLength = 12;
  static const pbkdf2Iterations = 120000;

  static final _aes = AesGcm.with256bits();
  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: pbkdf2Iterations,
    bits: 256,
  );

  static Future<Uint8List> encrypt({
    required Uint8List plaintext,
    required String password,
  }) async {
    if (password.length < 8) {
      throw const BackupFailure(
        message: 'Backup password must be at least 8 characters.',
      );
    }
    final salt = _randomBytes(saltLength);
    final key = await _deriveKey(password, salt);
    final secretBox = await _aes.encrypt(plaintext, secretKey: key);

    final builder = BytesBuilder(copy: false);
    builder.add(utf8.encode(magic));
    builder.addByte(formatVersion);
    builder.add(salt);
    builder.add(secretBox.nonce);
    builder.add(secretBox.cipherText);
    builder.add(secretBox.mac.bytes);
    return builder.toBytes();
  }

  static Future<Uint8List> decrypt({
    required Uint8List package,
    required String password,
  }) async {
    if (package.length < magic.length + 1 + saltLength + nonceLength + 16) {
      throw const RestoreFailure(message: 'Backup file is too small or corrupt.');
    }

    final magicBytes = package.sublist(0, magic.length);
    if (utf8.decode(magicBytes) != magic) {
      throw const RestoreFailure(message: 'Not a Shishur Dinlipi backup file.');
    }
    final version = package[magic.length];
    if (version != formatVersion) {
      throw RestoreFailure(
        message: 'Unsupported backup format version: $version',
      );
    }

    var offset = magic.length + 1;
    final salt = package.sublist(offset, offset + saltLength);
    offset += saltLength;
    final nonce = package.sublist(offset, offset + nonceLength);
    offset += nonceLength;
    // Last 16 bytes are GCM mac
    if (package.length < offset + 16) {
      throw const RestoreFailure(message: 'Backup file is corrupt.');
    }
    final macStart = package.length - 16;
    final cipherText = package.sublist(offset, macStart);
    final macBytes = package.sublist(macStart);

    final key = await _deriveKey(password, Uint8List.fromList(salt));
    try {
      final clear = await _aes.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
        secretKey: key,
      );
      return Uint8List.fromList(clear);
    } catch (error) {
      throw RestoreFailure(
        message: 'Wrong backup password or corrupt backup.',
        cause: error,
      );
    }
  }

  static Future<SecretKey> _deriveKey(String password, Uint8List salt) {
    return _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  static Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }
}
