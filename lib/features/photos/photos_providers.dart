import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/photo_library_item.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final photoLibraryGroupByProvider =
    StateProvider.autoDispose<PhotoLibraryGroupBy>(
  (ref) => PhotoLibraryGroupBy.all,
);

final photoLibraryGroupsProvider =
    FutureProvider.autoDispose<Map<String, List<PhotoLibraryItem>>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const {};
  final groupBy = ref.watch(photoLibraryGroupByProvider);
  return ref.watch(photoLibraryServiceProvider).group(
        childId: child.id,
        groupBy: groupBy,
        dateOfBirth: child.dateOfBirth,
      );
});

final photoLibraryItemProvider =
    FutureProvider.autoDispose.family<PhotoLibraryItem?, String>((ref, id) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return null;
  final photos = await ref
      .watch(photoLibraryServiceProvider)
      .photosForChild(child.id);
  for (final photo in photos) {
    if (photo.media.id == id) return photo;
  }
  return null;
});
