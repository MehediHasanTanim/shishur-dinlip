import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

enum PhotoSheetAction { camera, gallery, remove }

Future<PhotoSheetAction?> showPhotoSourceSheet(
  BuildContext context, {
  bool showRemove = false,
}) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<PhotoSheetAction>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.takePhoto),
              onTap: () => Navigator.pop(context, PhotoSheetAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseGallery),
              onTap: () => Navigator.pop(context, PhotoSheetAction.gallery),
            ),
            if (showRemove)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  l10n.removePhoto,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => Navigator.pop(context, PhotoSheetAction.remove),
              ),
            ListTile(
              title: Text(l10n.commonCancel),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
