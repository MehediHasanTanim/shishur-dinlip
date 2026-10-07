import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

/// PIN set / verify / change / remove with retry lockout.
class PinService {
  PinService(this._secure);

  final SecureStorageService _secure;

  static const minLength = 4;
  static const maxLength = 8;
  static const maxAttempts = 5;
  static const lockoutDuration = Duration(minutes: 1);
  static const _pbkdf2Iterations = 120000;

  Future<bool> isPinEnabled() =>
      _secure.readBool(SecureStorageKeys.pinEnabled);

  Future<void> setPin(String pin) async {
    _validateFormat(pin);
    final salt = _randomBytes(16);
    final hash = await _hashPin(pin, salt);
    await _secure.write(
      key: SecureStorageKeys.pinSalt,
      value: base64UrlEncode(salt),
    );
    await _secure.write(
      key: SecureStorageKeys.pinHash,
      value: base64UrlEncode(hash),
    );
    await _secure.writeBool(SecureStorageKeys.pinEnabled, true);
    await _clearAttempts();
  }

  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    final ok = await verifyPin(currentPin);
    if (!ok) {
      throw const SecurityFailure(message: 'Current PIN is incorrect.');
    }
    await setPin(newPin);
  }

  Future<void> removePin(String currentPin) async {
    final ok = await verifyPin(currentPin);
    if (!ok) {
      throw const SecurityFailure(message: 'Current PIN is incorrect.');
    }
    await _secure.delete(SecureStorageKeys.pinSalt);
    await _secure.delete(SecureStorageKeys.pinHash);
    await _secure.writeBool(SecureStorageKeys.pinEnabled, false);
    await _secure.writeBool(SecureStorageKeys.biometricsEnabled, false);
    await _clearAttempts();
  }

  Future<bool> verifyPin(String pin) async {
    await _throwIfLockedOut();
    final enabled = await isPinEnabled();
    if (!enabled) return true;

    final saltB64 = await _secure.read(SecureStorageKeys.pinSalt);
    final hashB64 = await _secure.read(SecureStorageKeys.pinHash);
    if (saltB64 == null || hashB64 == null) {
      throw const SecurityFailure(message: 'PIN is not configured.');
    }

    final salt = base64Url.decode(saltB64);
    final expected = base64Url.decode(hashB64);
    final actual = await _hashPin(pin, Uint8List.fromList(salt));
    final match = _constantTimeEquals(expected, actual);
    if (match) {
      await _clearAttempts();
      return true;
    }

    final attempts =
        await _secure.readInt(SecureStorageKeys.failedPinAttempts) + 1;
    await _secure.writeInt(SecureStorageKeys.failedPinAttempts, attempts);
    if (attempts >= maxAttempts) {
      final until = DateTime.now()
          .toUtc()
          .add(lockoutDuration)
          .millisecondsSinceEpoch;
      await _secure.writeInt(SecureStorageKeys.pinLockUntil, until);
      throw const SecurityFailure(
        message: 'Too many incorrect PIN attempts. Try again later.',
        lockedOut: true,
      );
    }
    final remaining = maxAttempts - attempts;
    throw SecurityFailure(
      message: 'Incorrect PIN. $remaining attempts remaining.',
    );
  }

  Future<Duration?> lockoutRemaining() async {
    final untilMs = await _secure.readInt(SecureStorageKeys.pinLockUntil);
    if (untilMs <= 0) return null;
    final until = DateTime.fromMillisecondsSinceEpoch(untilMs, isUtc: true);
    final remaining = until.difference(DateTime.now().toUtc());
    if (remaining.isNegative) {
      await _clearAttempts();
      return null;
    }
    return remaining;
  }

  void _validateFormat(String pin) {
    if (pin.length < minLength || pin.length > maxLength) {
      throw SecurityFailure(
        message: 'PIN must be $minLength–$maxLength digits.',
      );
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw const SecurityFailure(message: 'PIN must contain only digits.');
    }
  }

  Future<Uint8List> _hashPin(String pin, Uint8List salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _pbkdf2Iterations,
      bits: 256,
    );
    final key = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _throwIfLockedOut() async {
    final remaining = await lockoutRemaining();
    if (remaining != null) {
      throw SecurityFailure(
        message:
            'Too many attempts. Try again in ${remaining.inSeconds} seconds.',
        lockedOut: true,
      );
    }
  }

  Future<void> _clearAttempts() async {
    await _secure.writeInt(SecureStorageKeys.failedPinAttempts, 0);
    await _secure.delete(SecureStorageKeys.pinLockUntil);
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
