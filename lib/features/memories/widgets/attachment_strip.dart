import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/features/children/widgets/photo_source_sheet.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AttachmentStrip extends StatelessWidget {
  const AttachmentStrip({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  final AttachmentDraftsController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final drafts = controller.drafts;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.attachmentsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (enabled)
                  TextButton.icon(
                    onPressed: () => _pick(context),
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(l10n.addPhotos),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (drafts.isEmpty)
              Text(
                l10n.attachmentsEmpty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            else
              SizedBox(
                height: 104,
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  itemCount: drafts.length,
                  onReorderItem: enabled
                      ? (oldIndex, newIndex) =>
                          controller.reorder(oldIndex, newIndex)
                      : null,
                  itemBuilder: (context, index) {
                    final draft = drafts[index];
                    final file = controller.previewFiles[draft.localKey];
                    return Padding(
                      key: ValueKey(draft.localKey),
                      padding: const EdgeInsets.only(right: 8),
                      child: _Thumb(
                        file: file,
                        enabled: enabled,
                        index: index,
                        onRemove: () => controller.removeAt(index),
                        onPreview: file == null
                            ? null
                            : () => _preview(context, file),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pick(BuildContext context) async {
    final action = await showPhotoSourceSheet(context);
    if (action == null || !context.mounted) return;
    final source = action == PhotoSheetAction.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    try {
      await controller.addFromSource(source);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  void _preview(BuildContext context, File file) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          child: Image.file(file, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.file,
    required this.enabled,
    required this.index,
    required this.onRemove,
    this.onPreview,
  });

  final File? file;
  final bool enabled;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPreview,
                child: file == null
                    ? const Icon(Icons.broken_image_outlined)
                    : Image.file(file!, fit: BoxFit.cover),
              ),
            ),
          ),
          if (enabled)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          if (enabled)
            Positioned(
              bottom: 4,
              left: 4,
              child: ReorderableDragStartListener(
                index: index,
                child: const Material(
                  color: Colors.black45,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
