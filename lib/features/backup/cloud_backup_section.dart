import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class CloudBackupSection extends ConsumerStatefulWidget {
  const CloudBackupSection({super.key});

  @override
  ConsumerState<CloudBackupSection> createState() => _CloudBackupSectionState();
}

class _CloudBackupSectionState extends ConsumerState<CloudBackupSection> {
  BackupProviderId? _expanded;
  final _signedIn = <BackupProviderId, bool>{};
  final _remote = <BackupProviderId, List<RemoteBackup>>{};
  final _busy = <BackupProviderId, bool>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshStatuses());
  }

  Future<void> _refreshStatuses() async {
    final registry = ref.read(cloudBackupRegistryProvider);
    for (final provider in registry.cloudProviders) {
      final signedIn =
          provider.isConfigured && await provider.isSignedIn();
      if (!mounted) return;
      setState(() => _signedIn[provider.id] = signedIn);
      if (signedIn) {
        await _loadRemote(provider.id);
      }
    }
  }

  Future<void> _loadRemote(BackupProviderId id) async {
    setState(() => _busy[id] = true);
    try {
      final items = await ref.read(cloudBackupServiceProvider).list(id);
      if (!mounted) return;
      setState(() => _remote[id] = items);
    } on AppFailure catch (e) {
      if (!mounted) return;
      _snack(e.message ?? AppLocalizations.of(context).errorGeneric);
    } finally {
      if (mounted) setState(() => _busy[id] = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _providerLabel(AppLocalizations l10n, BackupProviderId id) {
    return switch (id) {
      BackupProviderId.googleDrive => l10n.cloudProviderGoogleDrive,
      BackupProviderId.oneDrive => l10n.cloudProviderOneDrive,
      BackupProviderId.dropbox => l10n.cloudProviderDropbox,
      BackupProviderId.iCloud => l10n.cloudProviderICloud,
      BackupProviderId.local => l10n.cloudProviderLocal,
    };
  }

  IconData _providerIcon(BackupProviderId id) {
    return switch (id) {
      BackupProviderId.googleDrive => Icons.cloud_outlined,
      BackupProviderId.oneDrive => Icons.cloud_queue_outlined,
      BackupProviderId.dropbox => Icons.cloud_circle_outlined,
      BackupProviderId.iCloud => Icons.phone_iphone_outlined,
      BackupProviderId.local => Icons.phone_android_outlined,
    };
  }

  Future<void> _connect(BackupProvider provider) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy[provider.id] = true);
    try {
      await provider.connect();
      if (!mounted) return;
      setState(() => _signedIn[provider.id] = true);
      await _loadRemote(provider.id);
    } on AppFailure catch (e) {
      if (mounted) _snack(e.message ?? l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy[provider.id] = false);
    }
  }

  Future<void> _disconnect(BackupProvider provider) async {
    await provider.disconnect();
    if (!mounted) return;
    setState(() {
      _signedIn[provider.id] = false;
      _remote[provider.id] = const [];
    });
  }

  Future<void> _upload(BackupProviderId id) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy[id] = true);
    try {
      await ref.read(cloudBackupServiceProvider).uploadLatestLocal(
            providerId: id,
          );
      if (!mounted) return;
      _snack(l10n.cloudBackupUploaded);
      await _loadRemote(id);
    } on AppFailure catch (e) {
      if (mounted) _snack(e.message ?? l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy[id] = false);
    }
  }

  Future<void> _download(RemoteBackup item) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy[item.providerId] = true);
    try {
      final file =
          await ref.read(cloudBackupServiceProvider).downloadToTemp(item);
      if (!mounted) return;
      _snack(l10n.cloudBackupDownloaded);
      await Share.shareXFiles([XFile(file.path)]);
    } on AppFailure catch (e) {
      if (mounted) _snack(e.message ?? l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy[item.providerId] = false);
    }
  }

  Future<void> _delete(RemoteBackup item) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy[item.providerId] = true);
    try {
      await ref.read(cloudBackupServiceProvider).deleteRemote(item);
      if (!mounted) return;
      _snack(l10n.cloudBackupDeleted);
      await _loadRemote(item.providerId);
    } on AppFailure catch (e) {
      if (mounted) _snack(e.message ?? l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy[item.providerId] = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final providers = ref.watch(cloudBackupRegistryProvider).cloudProviders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cloudBackupTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.cloudBackupSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        for (final provider in providers) ...[
          Card(
            child: ExpansionTile(
              leading: Icon(_providerIcon(provider.id)),
              title: Text(_providerLabel(l10n, provider.id)),
              subtitle: Text(_statusLabel(l10n, provider)),
              initiallyExpanded: _expanded == provider.id,
              onExpansionChanged: (open) {
                setState(() => _expanded = open ? provider.id : null);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _providerBody(l10n, provider),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  String _statusLabel(AppLocalizations l10n, BackupProvider provider) {
    if (!provider.isSupported) return l10n.cloudBackupUnsupported;
    if (!provider.isConfigured) return l10n.cloudBackupNotConfigured;
    if (_signedIn[provider.id] == true) return l10n.cloudBackupConnected;
    return l10n.cloudBackupConnect;
  }

  Widget _providerBody(AppLocalizations l10n, BackupProvider provider) {
    final busy = _busy[provider.id] == true;
    if (!provider.isSupported || !provider.isConfigured) {
      return Text(
        !provider.isSupported
            ? l10n.cloudBackupUnsupported
            : l10n.cloudBackupNotConfigured,
      );
    }

    final signedIn = _signedIn[provider.id] == true;
    final remotes = _remote[provider.id] ?? const <RemoteBackup>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (!signedIn)
              FilledButton(
                onPressed: busy ? null : () => _connect(provider),
                child: Text(l10n.cloudBackupConnect),
              )
            else ...[
              OutlinedButton(
                onPressed: busy ? null : () => _disconnect(provider),
                child: Text(l10n.cloudBackupDisconnect),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: l10n.cloudBackupRefresh,
                onPressed: busy ? null : () => _loadRemote(provider.id),
                icon: const Icon(Icons.refresh),
              ),
            ],
            if (busy) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        if (signedIn) ...[
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: busy ? null : () => _upload(provider.id),
            icon: const Icon(Icons.cloud_upload_outlined),
            label: Text(l10n.cloudBackupUploadLatest),
          ),
          const SizedBox(height: 12),
          if (remotes.isEmpty)
            Text(l10n.cloudBackupRemoteEmpty)
          else
            ...remotes.map((item) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.fileName),
                subtitle: Text(
                  '${item.createdAt.toLocal()} · ${_formatBytes(item.byteSize)}',
                ),
                trailing: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(
                      tooltip: l10n.cloudBackupDownload,
                      onPressed: busy ? null : () => _download(item),
                      icon: const Icon(Icons.download_outlined),
                    ),
                    IconButton(
                      tooltip: l10n.cloudBackupDelete,
                      onPressed: busy ? null : () => _delete(item),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            }),
        ],
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
