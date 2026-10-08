import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/ocr/ocr_models.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/features/ocr/ocr_labels.dart';
import 'package:shishur_dinlipi/features/ocr/ocr_script_picker.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OcrCaptureScreen extends ConsumerStatefulWidget {
  const OcrCaptureScreen({super.key, required this.scanType});

  final OcrScanType scanType;

  @override
  ConsumerState<OcrCaptureScreen> createState() => _OcrCaptureScreenState();
}

class _OcrCaptureScreenState extends ConsumerState<OcrCaptureScreen> {
  final _picker = ImagePicker();
  String? _imagePath;
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    final l10n = AppLocalizations.of(context);
    final permissions = ref.read(permissionServiceProvider);
    final ok = await permissions.ensure(
      source == ImageSource.camera
          ? AppPermission.camera
          : AppPermission.photos,
    );
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPermission)),
        );
      }
      return;
    }
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 92,
      maxWidth: 2400,
    );
    if (file == null) return;
    setState(() => _imagePath = file.path);
  }

  Future<void> _runScan() async {
    final l10n = AppLocalizations.of(context);
    final path = _imagePath;
    if (path == null) return;
    setState(() => _busy = true);
    try {
      final draft = await ref.read(ocrScanServiceProvider).scan(
            scanType: widget.scanType,
            imageFile: File(path),
          );
      if (!mounted) return;
      context.push(AppRoutes.ocrReview, extra: draft);
    } on AppFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? l10n.errorGeneric)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.ocrFailed)),
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
      appBar: AppBar(
        title: Text(ocrScanTypeLabel(l10n, widget.scanType)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.ocrCaptureHint,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          const OcrScriptPicker(),
          const SizedBox(height: 16),
          if (_imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_imagePath!),
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
          ] else
            Container(
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(l10n.ocrNoImageYet),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.ocrTakePhoto),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.ocrChoosePhoto),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy || _imagePath == null ? null : _runScan,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.document_scanner_outlined),
            label: Text(l10n.ocrScanNow),
          ),
        ],
      ),
    );
  }
}
