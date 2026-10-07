import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/backup/backup_manifest.dart';
import 'package:shishur_dinlipi/core/backup/backup_service.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

final backupHistoryProvider = FutureProvider.autoDispose<List<BackupHistoryEntry>>(
  (ref) => ref.watch(backupServiceProvider).listLocalHistory(),
);

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  BackupProgress? _progress;
  var _busy = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _progress = const BackupProgress(stage: BackupStage.preparing);
    });
    try {
      final result = await ref.read(backupServiceProvider).createBackup(
        password: _password.text,
        confirmPassword: _confirm.text,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      ref.invalidate(backupHistoryProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
      await Share.shareXFiles(
        [XFile(result.absolutePath, mimeType: 'application/octet-stream')],
        subject: result.fileName,
      );
    } on AppFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final historyAsync = ref.watch(backupHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupTitle),
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.restore),
            child: Text(l10n.backupRestoreCta),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.backupSubtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.backupPassword,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirm,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.backupPasswordConfirm,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_busy && _progress != null) ...[
            Text(_stageLabel(l10n, _progress!.stage)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progress!.fraction.clamp(0.05, 1),
            ),
            const SizedBox(height: 16),
          ],
          FilledButton.icon(
            onPressed: _busy ? null : _create,
            icon: const Icon(Icons.backup_outlined),
            label: Text(l10n.backupCreate),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.backupHistory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (items) {
              if (items.isEmpty) {
                return Text(l10n.backupHistoryEmpty);
              }
              return Column(
                children: items.map((e) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.folder_zip_outlined),
                      title: Text(e.fileName),
                      subtitle: Text(
                        '${e.createdAt.toLocal()} · ${_formatBytes(e.byteSize)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.ios_share),
                        onPressed: () => Share.shareXFiles([
                          XFile(e.absolutePath),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _stageLabel(AppLocalizations l10n, BackupStage stage) {
    return switch (stage) {
      BackupStage.preparing => l10n.backupStagePreparing,
      BackupStage.snapshotDatabase => l10n.backupStageDatabase,
      BackupStage.collectingMedia => l10n.backupStageMedia,
      BackupStage.buildingArchive => l10n.backupStageArchive,
      BackupStage.encrypting => l10n.backupStageEncrypting,
      BackupStage.saving => l10n.backupStageSaving,
      BackupStage.complete => l10n.backupStageComplete,
      BackupStage.failed => l10n.backupStageFailed,
    };
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
