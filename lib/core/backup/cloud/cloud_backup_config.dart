/// OAuth client configuration for optional cloud backup providers.
///
/// Supply via `--dart-define` at build time. Empty values mean the provider
/// is compiled in but not connectable until configured.
class CloudBackupConfig {
  const CloudBackupConfig({
    this.googleDriveClientId = '',
    this.oneDriveClientId = '',
    this.dropboxClientId = '',
    this.redirectScheme = 'shishurdinlipi',
  });

  factory CloudBackupConfig.fromEnvironment() {
    return const CloudBackupConfig(
      googleDriveClientId: String.fromEnvironment(
        'GOOGLE_DRIVE_CLIENT_ID',
        defaultValue: '',
      ),
      oneDriveClientId: String.fromEnvironment(
        'ONEDRIVE_CLIENT_ID',
        defaultValue: '',
      ),
      dropboxClientId: String.fromEnvironment(
        'DROPBOX_CLIENT_ID',
        defaultValue: '',
      ),
      redirectScheme: String.fromEnvironment(
        'CLOUD_BACKUP_REDIRECT_SCHEME',
        defaultValue: 'shishurdinlipi',
      ),
    );
  }

  final String googleDriveClientId;
  final String oneDriveClientId;
  final String dropboxClientId;
  final String redirectScheme;

  String get redirectUri => '$redirectScheme://oauth/callback';

  bool get googleDriveConfigured => googleDriveClientId.trim().isNotEmpty;
  bool get oneDriveConfigured => oneDriveClientId.trim().isNotEmpty;
  bool get dropboxConfigured => dropboxClientId.trim().isNotEmpty;
}
