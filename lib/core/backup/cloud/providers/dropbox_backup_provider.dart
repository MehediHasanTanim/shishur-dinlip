import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_config.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_session.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// Dropbox **app folder** backup provider.
class DropboxBackupProvider extends BackupProvider {
  DropboxBackupProvider({
    required CloudBackupConfig config,
    required OAuthAuthorizer authorizer,
    required CloudHttpClient http,
    required OAuthTokenStore tokenStore,
  }) : _config = config,
       _http = http,
       _session = OAuthSession(
         providerId: BackupProviderId.dropbox,
         clientId: config.dropboxClientId,
         authorizationEndpoint: Uri.parse(
           'https://www.dropbox.com/oauth2/authorize',
         ),
         tokenEndpoint: Uri.parse('https://api.dropboxapi.com/oauth2/token'),
         redirectUri: config.redirectUri,
         scopes: const [],
         authorizer: authorizer,
         http: http,
         tokenStore: tokenStore,
         extraAuthParams: const {
           'token_access_type': 'offline',
         },
       );

  final CloudBackupConfig _config;
  final CloudHttpClient _http;
  final OAuthSession _session;

  static const _folder = '/ShishurDinlipi';

  @override
  BackupProviderId get id => BackupProviderId.dropbox;

  @override
  String get name => 'dropbox';

  @override
  bool get isConfigured => _config.dropboxConfigured;

  @override
  Future<bool> isSignedIn() => _session.isSignedIn;

  @override
  Future<void> connect() => _session.connect();

  @override
  Future<void> disconnect() => _session.disconnect();

  String _pathFor(String fileName) => '$_folder/$fileName';

  @override
  Future<RemoteBackup> upload(BackupUploadFile file) async {
    final bytes = await file.file.readAsBytes();
    final token = await _session.accessToken();
    final remotePath = _pathFor(file.fileName);
    final response = await _http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: Uri.parse('https://content.dropboxapi.com/2/files/upload'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/octet-stream',
          'Dropbox-API-Arg': jsonEncode({
            'path': remotePath,
            'mode': 'overwrite',
            'autorename': false,
            'mute': true,
          }),
        },
        bodyBytes: bytes,
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'upload');
    }
    final json = _session.decodeJsonObject(response);
    return RemoteBackup(
      id: json['id'] as String? ?? remotePath,
      fileName: file.fileName,
      providerId: id,
      createdAt: DateTime.tryParse(
            (json['server_modified'] ?? json['client_modified']) as String? ??
                '',
          )?.toUtc() ??
          DateTime.now().toUtc(),
      byteSize: (json['size'] as int?) ?? bytes.length,
      remotePath: json['path_display'] as String? ?? remotePath,
    );
  }

  @override
  Future<List<RemoteBackup>> list() async {
    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: Uri.parse('https://api.dropboxapi.com/2/files/list_folder'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'path': _folder,
          'recursive': false,
          'include_deleted': false,
        }),
      ),
    );
    // Empty app folder may return path/not_found — treat as empty list.
    if (!response.isSuccess) {
      if (response.body.contains('path/not_found')) {
        return const [];
      }
      _session.throwHttp(response, 'list');
    }
    final json = _session.decodeJsonObject(response);
    final entries = (json['entries'] as List?) ?? const [];
    final items = <RemoteBackup>[];
    for (final raw in entries) {
      if (raw is! Map) continue;
      final m = Map<String, dynamic>.from(raw);
      if (m['.tag'] != 'file') continue;
      final name = m['name'] as String? ?? '';
      if (!name.endsWith('.sdjbackup')) continue;
      items.add(
        RemoteBackup(
          id: m['id'] as String? ?? (m['path_display'] as String? ?? name),
          fileName: name,
          providerId: id,
          createdAt: DateTime.tryParse(
                (m['server_modified'] ?? m['client_modified']) as String? ?? '',
              )?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          byteSize: (m['size'] as int?) ?? 0,
          remotePath: m['path_display'] as String?,
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
    final path = backup.remotePath ?? _pathFor(backup.fileName);
    final response = await _http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: Uri.parse('https://content.dropboxapi.com/2/files/download'),
        headers: {
          'Authorization': 'Bearer $token',
          'Dropbox-API-Arg': jsonEncode({'path': path}),
        },
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
    final path = backup.remotePath ?? _pathFor(backup.fileName);
    if (path.isEmpty) {
      throw const BackupFailure(message: 'Missing remote backup path.');
    }
    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: Uri.parse('https://api.dropboxapi.com/2/files/delete_v2'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'path': path}),
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'delete');
    }
  }
}
