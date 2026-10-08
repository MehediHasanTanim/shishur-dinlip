import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/features/children/widgets/photo_source_sheet.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AttachmentStrip extends StatelessWidget {
  const AttachmentStrip({
    super.key,
    required this.controller,
    this.enabled = true,
    this.allowDocuments = false,
  });

  final AttachmentDraftsController controller;
  final bool enabled;
  final bool allowDocuments;

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
                  allowDocuments
                      ? l10n.attachmentsAndDocsTitle
                      : l10n.attachmentsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (enabled) ...[
                  TextButton.icon(
                    onPressed: () => _pickPhoto(context),
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(l10n.addPhotos),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickVideo(context),
                    icon: const Icon(Icons.videocam_outlined),
                    label: Text(l10n.attachVideo),
                  ),
                  if (allowDocuments)
                    TextButton.icon(
                      onPressed: () => _pickDoc(context),
                      icon: const Icon(Icons.attach_file),
                      label: Text(l10n.addDocument),
                    ),
                ],
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
                    final isDoc = controller.isDocument(draft.localKey);
                    final isVid = controller.isVideo(draft.localKey);
                    return Padding(
                      key: ValueKey(draft.localKey),
                      padding: const EdgeInsets.only(right: 8),
                      child: _Thumb(
                        file: file,
                        isDocument: isDoc,
                        isVideo: isVid,
                        label: draft.displayName,
                        enabled: enabled,
                        index: index,
                        onRemove: () => controller.removeAt(index),
                        onPreview: file == null
                            ? null
                            : () => isDoc
                                  ? _shareDoc(context, file, draft.displayName)
                                  : _preview(context, file),
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

  Future<void> _pickPhoto(BuildContext context) async {
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

  Future<void> _pickDoc(BuildContext context) async {
    try {
      await controller.addDocument();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      await controller.addVideo();
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

  Future<void> _shareDoc(BuildContext context, File file, String? name) async {
    await Share.shareXFiles([XFile(file.path, name: name)], subject: name);
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.file,
    required this.enabled,
    required this.index,
    required this.onRemove,
    required this.isDocument,
    required this.isVideo,
    this.label,
    this.onPreview,
  });

  final File? file;
  final bool enabled;
  final int index;
  final VoidCallback onRemove;
  final bool isDocument;
  final bool isVideo;
  final String? label;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                child: isDocument
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              label ?? 'PDF',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      )
                    : file == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVideo
                                ? Icons.videocam_outlined
                                : Icons.broken_image_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          if (isVideo) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n.videoUnsupportedPreview,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ],
                      )
                    : Image.file(file!, fit: BoxFit.cover),
              ),
            ),
          ),
          if (isVideo && file != null)
            const Positioned(
              bottom: 6,
              right: 6,
              child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 22),
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
