import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/backup/backup_manifest.dart';
import 'package:shishur_dinlipi/core/backup/restore_service.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class RestoreScreen extends ConsumerStatefulWidget {
  const RestoreScreen({super.key});

  @override
  ConsumerState<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends ConsumerState<RestoreScreen> {
  final _password = TextEditingController();
  final _safetyPassword = TextEditingController();
  File? _file;
  RestorePreview? _preview;
  RestoreProgress? _progress;
  var _busy = false;
  var _done = false;

  @override
  void dispose() {
    _password.dispose();
    _safetyPassword.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;
    setState(() {
      _file = File(path);
      _preview = null;
      _done = false;
    });
  }

  Future<void> _validate() async {
    final file = _file;
    if (file == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _progress = const RestoreProgress(stage: RestoreStage.reading);
    });
    try {
      final preview = await ref.read(restoreServiceProvider).prepare(
        backupFile: file,
        password: _password.text,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      if (mounted) setState(() => _preview = preview);
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

  Future<void> _commit() async {
    final preview = _preview;
    if (preview == null) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.restoreConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restoreConfirmCta),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _progress = const RestoreProgress(stage: RestoreStage.safetyBackup);
    });
    try {
      await ref.read(restoreServiceProvider).commit(
        preview: preview,
        safetyPassword: _safetyPassword.text.trim().isEmpty
            ? null
            : _safetyPassword.text.trim(),
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      if (mounted) {
        setState(() {
          _done = true;
          _preview = null;
        });
      }
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.restoreTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.restoreSubtitle),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _busy ? null : _pick,
            icon: const Icon(Icons.folder_open_outlined),
            label: Text(
              _file == null ? l10n.restorePick : _file!.uri.pathSegments.last,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l10n.backupPassword,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy || _file == null ? null : _validate,
            child: Text(l10n.restoreValidate),
          ),
          if (_busy && _progress != null) ...[
            const SizedBox(height: 16),
            Text(_stageLabel(l10n, _progress!.stage)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progress!.fraction.clamp(0.05, 1),
            ),
          ],
          if (_preview != null) ...[
            const SizedBox(height: 24),
            Text(
              l10n.restorePreviewTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _PreviewCard(manifest: _preview!.manifest),
            const SizedBox(height: 12),
            TextField(
              controller: _safetyPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.restoreSafetyPassword,
                helperText: l10n.restoreSafetyPasswordHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _commit,
              child: Text(l10n.restoreCommit),
            ),
          ],
          if (_done) ...[
            const SizedBox(height: 24),
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.restoreRestartRequired,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }

  String _stageLabel(AppLocalizations l10n, RestoreStage stage) {
    return switch (stage) {
      RestoreStage.reading => l10n.restoreStageReading,
      RestoreStage.decrypting => l10n.restoreStageDecrypting,
      RestoreStage.validating => l10n.restoreStageValidating,
      RestoreStage.preview => l10n.restoreStagePreview,
      RestoreStage.safetyBackup => l10n.restoreStageSafety,
      RestoreStage.restoring => l10n.restoreStageRestoring,
      RestoreStage.migrating => l10n.restoreStageMigrating,
      RestoreStage.rebuilding => l10n.restoreStageRebuilding,
      RestoreStage.complete => l10n.restoreStageComplete,
      RestoreStage.failed => l10n.restoreStageFailed,
    };
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.manifest});

  final BackupManifest manifest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.restorePreviewChildren(manifest.childCount)),
            Text(l10n.restorePreviewAssets(manifest.assetCount)),
            Text(
              l10n.restorePreviewSchema(manifest.databaseSchemaVersion),
            ),
            Text(l10n.restorePreviewApp(manifest.appVersion)),
            if (manifest.childNames.isNotEmpty)
              Text(manifest.childNames.join(', ')),
          ],
        ),
      ),
    );
  }
}
