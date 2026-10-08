import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_backup_config.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/dropbox_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/google_drive_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/icloud_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/local_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/providers/onedrive_backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/security/secure_storage_service.dart';

/// Holds every [BackupProvider] behind the common abstraction.
class CloudBackupRegistry {
  CloudBackupRegistry({
    required List<BackupProvider> providers,
  }) : _byId = {for (final p in providers) p.id: p};

  factory CloudBackupRegistry.production({
    required BackupService backupService,
    required FileStorageService storage,
    required SecureStorageService secureStorage,
    CloudBackupConfig? config,
    OAuthAuthorizer? authorizer,
    CloudHttpClient? http,
  }) {
    final cfg = config ?? CloudBackupConfig.fromEnvironment();
    final auth = authorizer ?? const FlutterWebAuthAuthorizer();
    final client = http ?? DartCloudHttpClient();
    final tokens = OAuthTokenStore(secureStorage);
    return CloudBackupRegistry(
      providers: [
        LocalBackupProvider(
          backupService: backupService,
          storage: storage,
        ),
        GoogleDriveBackupProvider(
          config: cfg,
          authorizer: auth,
          http: client,
          tokenStore: tokens,
        ),
        OneDriveBackupProvider(
          config: cfg,
          authorizer: auth,
          http: client,
          tokenStore: tokens,
        ),
        DropboxBackupProvider(
          config: cfg,
          authorizer: auth,
          http: client,
          tokenStore: tokens,
        ),
        ICloudBackupProvider(),
      ],
    );
  }

  final Map<BackupProviderId, BackupProvider> _byId;

  List<BackupProvider> get all => _byId.values.toList(growable: false);

  List<BackupProvider> get cloudProviders => all
      .where((p) => p.id != BackupProviderId.local)
      .toList(growable: false);

  BackupProvider? operator [](BackupProviderId id) => _byId[id];

  BackupProvider require(BackupProviderId id) {
    final p = _byId[id];
    if (p == null) {
      throw StateError('Unknown backup provider: $id');
    }
    return p;
  }
}
