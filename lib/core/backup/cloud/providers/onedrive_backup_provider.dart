import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_config.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_session.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// Microsoft OneDrive app folder via Graph `special/approot`.
class OneDriveBackupProvider extends BackupProvider {
  OneDriveBackupProvider({
    required CloudBackupConfig config,
    required OAuthAuthorizer authorizer,
    required CloudHttpClient http,
    required OAuthTokenStore tokenStore,
  }) : _config = config,
       _http = http,
       _session = OAuthSession(
         providerId: BackupProviderId.oneDrive,
         clientId: config.oneDriveClientId,
         authorizationEndpoint: Uri.parse(
           'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
         ),
         tokenEndpoint: Uri.parse(
           'https://login.microsoftonline.com/common/oauth2/v2.0/token',
         ),
         redirectUri: config.redirectUri,
         scopes: const [
           'offline_access',
           'Files.ReadWrite.AppFolder',
           'User.Read',
         ],
         authorizer: authorizer,
         http: http,
         tokenStore: tokenStore,
       );

  final CloudBackupConfig _config;
  final CloudHttpClient _http;
  final OAuthSession _session;

  @override
  BackupProviderId get id => BackupProviderId.oneDrive;

  @override
  String get name => 'onedrive';

  @override
  bool get isConfigured => _config.oneDriveConfigured;

  @override
  Future<bool> isSignedIn() => _session.isSignedIn;

  @override
  Future<void> connect() => _session.connect();

  @override
  Future<void> disconnect() => _session.disconnect();

  @override
  Future<RemoteBackup> upload(BackupUploadFile file) async {
    final bytes = await file.file.readAsBytes();
    final token = await _session.accessToken();
    final encodedName = Uri.encodeComponent(file.fileName);
    final response = await _http.send(
      CloudHttpRequest(
        method: 'PUT',
        uri: Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/special/approot:'
          '/$encodedName:/content',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/octet-stream',
        },
        bodyBytes: bytes,
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'upload');
    }
    final json = _session.decodeJsonObject(response);
    return RemoteBackup(
      id: json['id'] as String? ?? '',
      fileName: json['name'] as String? ?? file.fileName,
      providerId: id,
      createdAt: DateTime.tryParse(
            (json['createdDateTime'] ?? json['lastModifiedDateTime'])
                    as String? ??
                '',
          )?.toUtc() ??
          DateTime.now().toUtc(),
      byteSize: (json['size'] as int?) ?? bytes.length,
      remotePath: json['id'] as String?,
    );
  }

  @override
  Future<List<RemoteBackup>> list() async {
    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'GET',
        uri: Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/special/approot/children'
          '?\$select=id,name,size,createdDateTime,lastModifiedDateTime'
          '&\$top=100',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'list');
    }
    final json = _session.decodeJsonObject(response);
    final values = (json['value'] as List?) ?? const [];
    final items = <RemoteBackup>[];
    for (final raw in values) {
      if (raw is! Map) continue;
      final m = Map<String, dynamic>.from(raw);
      final name = m['name'] as String? ?? '';
      if (!name.endsWith('.sdjbackup')) continue;
      items.add(
        RemoteBackup(
          id: m['id'] as String? ?? '',
          fileName: name,
          providerId: id,
          createdAt: DateTime.tryParse(
                (m['createdDateTime'] ?? m['lastModifiedDateTime']) as String? ??
                    '',
              )?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          byteSize: (m['size'] as int?) ?? 0,
          remotePath: m['id'] as String?,
        ),
      );
    }
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<File> download(
    RemoteBackup backup, {
    required Directory toDirectory,
  }) async {
    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'GET',
        uri: Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/items/${backup.id}/content',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'download');
    }
    await toDirectory.create(recursive: true);
    final dest = File(p.join(toDirectory.path, backup.fileName));
    await dest.writeAsBytes(response.bodyBytes, flush: true);
    return dest;
  }

  @override
  Future<void> delete(RemoteBackup backup) async {
    if (backup.id.isEmpty) {
      throw const BackupFailure(message: 'Missing remote backup id.');
    }
    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'DELETE',
        uri: Uri.parse(
          'https://graph.microsoft.com/v1.0/me/drive/items/${backup.id}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (!response.isSuccess && response.statusCode != 204) {
      _session.throwHttp(response, 'delete');
    }
  }
}
