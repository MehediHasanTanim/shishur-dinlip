import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_config.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_session.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// Google Drive **appDataFolder** backup provider (OAuth + Drive v3).
class GoogleDriveBackupProvider extends BackupProvider {
  GoogleDriveBackupProvider({
    required CloudBackupConfig config,
    required OAuthAuthorizer authorizer,
    required CloudHttpClient http,
    required OAuthTokenStore tokenStore,
  }) : _config = config,
       _http = http,
       _session = OAuthSession(
         providerId: BackupProviderId.googleDrive,
         clientId: config.googleDriveClientId,
         authorizationEndpoint: Uri.parse(
           'https://accounts.google.com/o/oauth2/v2/auth',
         ),
         tokenEndpoint: Uri.parse('https://oauth2.googleapis.com/token'),
         redirectUri: config.redirectUri,
         scopes: const [
           'https://www.googleapis.com/auth/drive.appdata',
         ],
         authorizer: authorizer,
         http: http,
         tokenStore: tokenStore,
         extraAuthParams: const {
           'access_type': 'offline',
           'prompt': 'consent',
         },
       );

  final CloudBackupConfig _config;
  final CloudHttpClient _http;
  final OAuthSession _session;

  @override
  BackupProviderId get id => BackupProviderId.googleDrive;

  @override
  String get name => 'google_drive';

  @override
  bool get isConfigured => _config.googleDriveConfigured;

  @override
  Future<bool> isSignedIn() => _session.isSignedIn;

  @override
  Future<void> connect() => _session.connect();

  @override
  Future<void> disconnect() => _session.disconnect();

  @override
  Future<RemoteBackup> upload(BackupUploadFile file) async {
    final bytes = await file.file.readAsBytes();
    final boundary = 'sdj_${Random().nextInt(1 << 32)}';
    final meta = jsonEncode({
      'name': file.fileName,
      'parents': ['appDataFolder'],
    });
    final preamble = utf8.encode(
      '--$boundary\r\n'
      'Content-Type: application/json; charset=UTF-8\r\n\r\n'
      '$meta\r\n'
      '--$boundary\r\n'
      'Content-Type: application/octet-stream\r\n\r\n',
    );
    final closing = utf8.encode('\r\n--$boundary--');
    final body = Uint8List(preamble.length + bytes.length + closing.length)
      ..setAll(0, preamble)
      ..setAll(preamble.length, bytes)
      ..setAll(preamble.length + bytes.length, closing);

    final token = await _session.accessToken();
    final response = await _http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: Uri.parse(
          'https://www.googleapis.com/upload/drive/v3/files'
          '?uploadType=multipart&spaces=appDataFolder',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/related; boundary=$boundary',
        },
        bodyBytes: body,
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
      createdAt: DateTime.tryParse(json['createdTime'] as String? ?? '')
              ?.toUtc() ??
          DateTime.now().toUtc(),
      byteSize: bytes.length,
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
          'https://www.googleapis.com/drive/v3/files'
          '?spaces=appDataFolder'
          '&fields=files(id,name,size,createdTime,modifiedTime)'
          '&q=${Uri.encodeQueryComponent("name contains '.sdjbackup'")}'
          '&pageSize=100',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (!response.isSuccess) {
      _session.throwHttp(response, 'list');
    }
    final json = _session.decodeJsonObject(response);
    final files = (json['files'] as List?) ?? const [];
    final items = <RemoteBackup>[];
    for (final raw in files) {
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
                (m['createdTime'] ?? m['modifiedTime']) as String? ?? '',
              )?.toUtc() ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          byteSize: int.tryParse('${m['size'] ?? 0}') ?? 0,
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
          'https://www.googleapis.com/drive/v3/files/${backup.id}?alt=media',
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
          'https://www.googleapis.com/drive/v3/files/${backup.id}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    if (!response.isSuccess && response.statusCode != 204) {
      _session.throwHttp(response, 'delete');
    }
  }
}
