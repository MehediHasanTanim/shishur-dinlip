import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_config.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/dropbox_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/google_drive_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/icloud_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/onedrive_backup_provider.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

void main() {
  late Directory temp;
  late File sampleBackup;
  late SecureStorageService secure;
  late OAuthTokenStore tokens;
  late CloudBackupConfig config;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('sd_cloud_');
    sampleBackup = File(p.join(temp.path, 'demo.sdjbackup'));
    await sampleBackup.writeAsBytes(utf8.encode('encrypted-backup-bytes'));
    secure = SecureStorageService.memory();
    tokens = OAuthTokenStore(secure);
    config = const CloudBackupConfig(
      googleDriveClientId: 'google-client',
      oneDriveClientId: 'onedrive-client',
      dropboxClientId: 'dropbox-client',
      redirectScheme: 'shishurdinlipi',
    );
  });

  tearDown(() async {
    if (await temp.exists()) await temp.delete(recursive: true);
  });

  group('Google Drive', () {
    test('OAuth connect + upload list download delete', () async {
      final store = <String, Uint8List>{};
      final meta = <String, Map<String, dynamic>>{};
      var idSeq = 0;

      final http = FakeCloudHttpClient((request) async {
        final path = request.uri.path;
        if (request.uri.host.contains('oauth2.googleapis.com') &&
            path.endsWith('/token')) {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(
                jsonEncode({
                  'access_token': 'g-access',
                  'refresh_token': 'g-refresh',
                  'expires_in': 3600,
                  'token_type': 'Bearer',
                }),
              ),
            ),
          );
        }
        if (path.contains('/upload/drive/v3/files')) {
          idSeq += 1;
          final id = 'g$idSeq';
          // Body is multipart; store raw for simplicity after boundary scan.
          store[id] = request.bodyBytes ?? Uint8List(0);
          meta[id] = {
            'id': id,
            'name': 'demo.sdjbackup',
            'size': '${sampleBackup.lengthSync()}',
            'createdTime': '2026-01-02T03:04:05Z',
          };
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(utf8.encode(jsonEncode(meta[id]))),
          );
        }
        if (path == '/drive/v3/files' && request.method == 'GET') {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(jsonEncode({'files': meta.values.toList()})),
            ),
          );
        }
        if (path.startsWith('/drive/v3/files/') &&
            request.uri.queryParameters['alt'] == 'media') {
          final id = path.split('/').last;
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: store[id] ?? Uint8List(0),
          );
        }
        if (path.startsWith('/drive/v3/files/') && request.method == 'DELETE') {
          final id = path.split('/').last;
          store.remove(id);
          meta.remove(id);
          return CloudHttpResponse(
            statusCode: 204,
            bodyBytes: Uint8List(0),
          );
        }
        return CloudHttpResponse(
          statusCode: 404,
          bodyBytes: Uint8List.fromList(utf8.encode('missing ${request.uri}')),
        );
      });

      final authorizer = FakeOAuthAuthorizer(
        Uri.parse('shishurdinlipi://oauth/callback?code=abc'),
      );
      final provider = GoogleDriveBackupProvider(
        config: config,
        authorizer: authorizer,
        http: http,
        tokenStore: tokens,
      );

      expect(provider.isConfigured, isTrue);
      expect(await provider.isSignedIn(), isFalse);
      await provider.connect();
      expect(await provider.isSignedIn(), isTrue);
      expect(authorizer.lastAuthorizationUrl, isNotNull);
      expect(
        authorizer.lastAuthorizationUrl!.queryParameters['code_challenge_method'],
        'S256',
      );

      final uploaded = await provider.upload(
        BackupUploadFile(
          absolutePath: sampleBackup.path,
          fileName: 'demo.sdjbackup',
        ),
      );
      expect(uploaded.id, isNotEmpty);
      expect(uploaded.fileName, 'demo.sdjbackup');

      final listed = await provider.list();
      expect(listed, hasLength(1));

      final dlDir = Directory(p.join(temp.path, 'dl_g'));
      final downloaded = await provider.download(listed.first, toDirectory: dlDir);
      expect(await downloaded.exists(), isTrue);
      // Multipart body contains payload; ensure file was written.
      expect(await downloaded.length(), greaterThan(0));

      await provider.delete(listed.first);
      expect(await provider.list(), isEmpty);

      await provider.disconnect();
      expect(await provider.isSignedIn(), isFalse);
    });
  });

  group('OneDrive', () {
    test('CRUD via Graph approot', () async {
      final files = <String, Map<String, dynamic>>{};
      final blobs = <String, Uint8List>{};

      final http = FakeCloudHttpClient((request) async {
        if (request.uri.host.contains('login.microsoftonline.com')) {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(
                jsonEncode({
                  'access_token': 'ms-access',
                  'refresh_token': 'ms-refresh',
                  'expires_in': 3600,
                }),
              ),
            ),
          );
        }
        final path = request.uri.path;
        if (path.contains('/special/approot:') && request.method == 'PUT') {
          const id = 'od1';
          blobs[id] = request.bodyBytes ?? Uint8List(0);
          files[id] = {
            'id': id,
            'name': 'demo.sdjbackup',
            'size': blobs[id]!.length,
            'createdDateTime': '2026-02-01T00:00:00Z',
          };
          return CloudHttpResponse(
            statusCode: 201,
            bodyBytes: Uint8List.fromList(utf8.encode(jsonEncode(files[id]))),
          );
        }
        if (path.endsWith('/special/approot/children')) {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(jsonEncode({'value': files.values.toList()})),
            ),
          );
        }
        if (path.endsWith('/content') && request.method == 'GET') {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: blobs['od1'] ?? Uint8List(0),
          );
        }
        if (path.contains('/items/') && request.method == 'DELETE') {
          files.clear();
          blobs.clear();
          return CloudHttpResponse(
            statusCode: 204,
            bodyBytes: Uint8List(0),
          );
        }
        return CloudHttpResponse(
          statusCode: 500,
          bodyBytes: Uint8List.fromList(utf8.encode(request.uri.toString())),
        );
      });

      final provider = OneDriveBackupProvider(
        config: config,
        authorizer: FakeOAuthAuthorizer(
          Uri.parse('shishurdinlipi://oauth/callback?code=ms'),
        ),
        http: http,
        tokenStore: tokens,
      );

      await provider.connect();
      await provider.upload(
        BackupUploadFile(
          absolutePath: sampleBackup.path,
          fileName: 'demo.sdjbackup',
        ),
      );
      final listed = await provider.list();
      expect(listed.single.providerId, BackupProviderId.oneDrive);
      final file = await provider.download(
        listed.single,
        toDirectory: Directory(p.join(temp.path, 'dl_od')),
      );
      expect(await file.readAsBytes(), utf8.encode('encrypted-backup-bytes'));
      await provider.delete(listed.single);
      expect(await provider.list(), isEmpty);
    });
  });

  group('Dropbox', () {
    test('CRUD via app folder API', () async {
      final files = <String, Map<String, dynamic>>{};
      final blobs = <String, Uint8List>{};

      final http = FakeCloudHttpClient((request) async {
        if (request.uri.path.endsWith('/oauth2/token')) {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(
                jsonEncode({
                  'access_token': 'dbx-access',
                  'refresh_token': 'dbx-refresh',
                  'expires_in': 14400,
                }),
              ),
            ),
          );
        }
        if (request.uri.path.endsWith('/files/upload')) {
          final arg = jsonDecode(request.headers['Dropbox-API-Arg']!);
          final path = arg['path'] as String;
          blobs[path] = request.bodyBytes ?? Uint8List(0);
          files[path] = {
            '.tag': 'file',
            'id': 'id:$path',
            'name': p.basename(path),
            'path_display': path,
            'size': blobs[path]!.length,
            'server_modified': '2026-03-01T12:00:00Z',
          };
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(utf8.encode(jsonEncode(files[path]))),
          );
        }
        if (request.uri.path.endsWith('/files/list_folder')) {
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(
              utf8.encode(jsonEncode({'entries': files.values.toList()})),
            ),
          );
        }
        if (request.uri.path.endsWith('/files/download')) {
          final arg = jsonDecode(request.headers['Dropbox-API-Arg']!);
          final path = arg['path'] as String;
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: blobs[path] ?? Uint8List(0),
          );
        }
        if (request.uri.path.endsWith('/files/delete_v2')) {
          final body = jsonDecode(request.body!);
          final path = body['path'] as String;
          files.remove(path);
          blobs.remove(path);
          return CloudHttpResponse(
            statusCode: 200,
            bodyBytes: Uint8List.fromList(utf8.encode('{"metadata":{}}')),
          );
        }
        return CloudHttpResponse(
          statusCode: 404,
          bodyBytes: Uint8List(0),
        );
      });

      final provider = DropboxBackupProvider(
        config: config,
        authorizer: FakeOAuthAuthorizer(
          Uri.parse('shishurdinlipi://oauth/callback?code=dbx'),
        ),
        http: http,
        tokenStore: tokens,
      );

      await provider.connect();
      await provider.upload(
        BackupUploadFile(
          absolutePath: sampleBackup.path,
          fileName: 'demo.sdjbackup',
        ),
      );
      final listed = await provider.list();
      expect(listed, hasLength(1));
      final file = await provider.download(
        listed.single,
        toDirectory: Directory(p.join(temp.path, 'dl_dbx')),
      );
      expect(await file.readAsString(), 'encrypted-backup-bytes');
      await provider.delete(listed.single);
      expect(await provider.list(), isEmpty);
    });
  });

  test('iCloud provider is unsupported', () async {
    final provider = ICloudBackupProvider();
    expect(provider.isSupported, isFalse);
    expect(provider.isConfigured, isFalse);
    expect(await provider.isSignedIn(), isFalse);
    expect(provider.connect, throwsA(isA<BackupFailure>()));
  });

  test('token store round-trip', () async {
    final token = OAuthToken(
      accessToken: 'a',
      refreshToken: 'r',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
    await tokens.write(BackupProviderId.googleDrive, token);
    final read = await tokens.read(BackupProviderId.googleDrive);
    expect(read?.accessToken, 'a');
    expect(read?.refreshToken, 'r');
    await tokens.clear(BackupProviderId.googleDrive);
    expect(await tokens.read(BackupProviderId.googleDrive), isNull);
  });

  test('unconfigured provider refuses connect', () async {
    final provider = GoogleDriveBackupProvider(
      config: const CloudBackupConfig(),
      authorizer: FakeOAuthAuthorizer(
        Uri.parse('shishurdinlipi://oauth/callback?code=x'),
      ),
      http: FakeCloudHttpClient(
        (_) async => CloudHttpResponse(
          statusCode: 500,
          bodyBytes: Uint8List(0),
        ),
      ),
      tokenStore: tokens,
    );
    expect(provider.isConfigured, isFalse);
    expect(provider.connect, throwsA(isA<BackupFailure>()));
  });
}
