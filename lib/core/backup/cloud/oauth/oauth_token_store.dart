import 'dart:convert';

import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_keys.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

class OAuthTokenStore {
  OAuthTokenStore(this._secure);

  final SecureStorageService _secure;

  Future<OAuthToken?> read(BackupProviderId providerId) async {
    final raw = await _secure.read(_key(providerId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      final token = OAuthToken.fromJson(Map<String, dynamic>.from(map));
      if (token.accessToken.isEmpty) return null;
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<void> write(BackupProviderId providerId, OAuthToken token) {
    return _secure.write(
      key: _key(providerId),
      value: jsonEncode(token.toJson()),
    );
  }

  Future<void> clear(BackupProviderId providerId) {
    return _secure.delete(_key(providerId));
  }

  String _key(BackupProviderId id) {
    return switch (id) {
      BackupProviderId.googleDrive => SecureStorageKeys.oauthGoogleDrive,
      BackupProviderId.oneDrive => SecureStorageKeys.oauthOneDrive,
      BackupProviderId.dropbox => SecureStorageKeys.oauthDropbox,
      BackupProviderId.local || BackupProviderId.iCloud =>
        'oauth_unused_${id.name}',
    };
  }
}
