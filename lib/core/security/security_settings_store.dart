import 'package:shishur_dinlipi/core/security/auto_lock_mode.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

class SecuritySettings {
  const SecuritySettings({
    this.pinEnabled = false,
    this.biometricsEnabled = false,
    this.autoLock = AutoLockMode.immediately,
  });

  final bool pinEnabled;
  final bool biometricsEnabled;
  final AutoLockMode autoLock;

  bool get appLockEnabled => pinEnabled;
}

class SecuritySettingsStore {
  SecuritySettingsStore(this._secure);

  final SecureStorageService _secure;

  Future<SecuritySettings> load() async {
    final pin = await _secure.readBool(SecureStorageKeys.pinEnabled);
    final bio = await _secure.readBool(SecureStorageKeys.biometricsEnabled);
    final autoRaw = await _secure.read(SecureStorageKeys.autoLockMode);
    return SecuritySettings(
      pinEnabled: pin,
      biometricsEnabled: bio && pin,
      autoLock: AutoLockMode.fromStorage(autoRaw),
    );
  }

  Future<void> setAutoLock(AutoLockMode mode) {
    return _secure.write(
      key: SecureStorageKeys.autoLockMode,
      value: mode.name,
    );
  }
}
