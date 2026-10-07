import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final customAlbumsProvider =
    FutureProvider.autoDispose<List<Album>>((ref) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref
      .watch(albumsRepositoryProvider)
      .forChild(child.id, albumType: AlbumTypes.custom);
});

final albumDetailProvider =
    FutureProvider.autoDispose.family<Album?, String>((ref, id) async {
  return ref.watch(albumsRepositoryProvider).getById(id);
});
