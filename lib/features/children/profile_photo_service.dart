import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/domain/models/media_asset.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/media/media_service.dart';
import 'package:shishur_dinlipi/core/permissions/permission_service.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';

/// Handles profile photo pick → private import → child link.
class ProfilePhotoService {
  ProfilePhotoService({
    required this.mediaService,
    required this.childrenRepository,
    required this.fileStorage,
    required this.permissions,
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final MediaService mediaService;
  final ChildrenRepository childrenRepository;
  final FileStorageService fileStorage;
  final PermissionService permissions;
  final ImagePicker _picker;

  Future<MediaAsset?> pickAndAttach({
    required Child child,
    required ImageSource source,
  }) async {
    final permission = source == ImageSource.camera
        ? AppPermission.camera
        : AppPermission.photos;
    final allowed = await permissions.ensure(permission);
    if (!allowed) {
      throw const PermissionFailure(
        message: 'Permission is required to add a photo.',
      );
    }

    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 88,
    );
    if (file == null) return null;

    final asset = await mediaService.importImage(
      sourceFile: File(file.path),
      childId: child.id,
      originalFilename: file.name,
    );

    final previousPhotoId = child.profilePhotoId;
    await childrenRepository.save(child.copyWith(profilePhotoId: asset.id));

    if (previousPhotoId != null && previousPhotoId != asset.id) {
      await mediaService.deleteUnusedMediaSafely(previousPhotoId);
    }

    return asset;
  }

  Future<Child> removePhoto(Child child) async {
    final previous = child.profilePhotoId;
    final updated = child.copyWith(clearProfilePhotoId: true);
    final saved = await childrenRepository.save(updated);
    if (previous != null) {
      await mediaService.deleteUnusedMediaSafely(previous);
    }
    return saved;
  }

  Future<File?> resolvePhotoFile(String? mediaAssetId) async {
    if (mediaAssetId == null) return null;
    final asset = await mediaService.getById(mediaAssetId);
    if (asset == null) return null;
    final path = asset.thumbnailPath ?? asset.localPath;
    final file = await fileStorage.absoluteFile(path);
    if (!await file.exists()) return null;
    return file;
  }
}
