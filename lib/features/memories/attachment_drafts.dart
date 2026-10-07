import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/attachment.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/attachment_repository.dart';

/// Mutable attachment drafts for a single editor form.
class AttachmentDraftsController extends ChangeNotifier {
  AttachmentDraftsController({
    required this.attachments,
    required this.storage,
    required this.permissions,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final AttachmentRepository attachments;
  final FileStorageService storage;
  final PermissionService permissions;
  final ImagePicker _picker;

  List<AttachmentDraft> _drafts = const [];
  final Map<String, File> _previewFiles = {};

  List<AttachmentDraft> get drafts => _drafts;
  Map<String, File> get previewFiles => Map.unmodifiable(_previewFiles);

  Future<void> loadExisting({
    required String entityType,
    required String entityId,
  }) async {
    final items = await attachments.forEntity(
      entityType: entityType,
      entityId: entityId,
    );
    final drafts = <AttachmentDraft>[];
    _previewFiles.clear();

    for (final item in items) {
      final key = item.id;
      drafts.add(
        AttachmentDraft(
          localKey: key,
          attachmentId: item.id,
          mediaAssetId: item.mediaAssetId,
          caption: item.caption,
        ),
      );
      final media = item.media;
      if (media != null) {
        final path = media.thumbnailPath ?? media.localPath;
        final file = await storage.absoluteFile(path);
        if (await file.exists()) {
          _previewFiles[key] = file;
        }
      }
    }

    _drafts = drafts;
    notifyListeners();
  }

  Future<void> addFromSource(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? AppPermission.camera
        : AppPermission.photos;
    final allowed = await permissions.ensure(permission);
    if (!allowed) {
      throw const PermissionFailure(
        message: 'Permission is required to add a photo.',
      );
    }

    if (source == ImageSource.gallery) {
      final files = await _picker.pickMultiImage(
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );
      for (final file in files) {
        _appendPending(file.path);
      }
      return;
    }

    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 88,
    );
    if (file != null) _appendPending(file.path);
  }

  void _appendPending(String path) {
    final key = idGenerator.next();
    _drafts = [..._drafts, AttachmentDraft(localKey: key, pendingPath: path)];
    _previewFiles[key] = File(path);
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _drafts.length) return;
    final key = _drafts[index].localKey;
    _drafts = [..._drafts]..removeAt(index);
    _previewFiles.remove(key);
    notifyListeners();
  }

  /// [newIndex] is the destination after removal (Flutter `onReorderItem` style).
  void reorder(int oldIndex, int newIndex) {
    final drafts = [..._drafts];
    final item = drafts.removeAt(oldIndex);
    drafts.insert(newIndex, item);
    _drafts = drafts;
    notifyListeners();
  }
}
