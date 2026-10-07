import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/core/repository/children_repository.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';

final childrenListProvider =
    AsyncNotifierProvider<ChildrenListController, List<Child>>(
      ChildrenListController.new,
    );

class ChildrenListController extends AsyncNotifier<List<Child>> {
  ChildrenRepository get _repo => ref.read(childrenRepositoryProvider);

  @override
  Future<List<Child>> build() => _repo.getChildren();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.getChildren);
  }

  Future<Child> save(Child child) async {
    final saved = await _repo.save(child);
    await refresh();
    return saved;
  }

  Future<void> softDelete(String id) async {
    await _repo.softDelete(id);
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    if (settings?.selectedChildId == id) {
      final remaining = await _repo.getChildren();
      await ref
          .read(settingsControllerProvider.notifier)
          .setSelectedChildId(remaining.isEmpty ? null : remaining.first.id);
    }
    await refresh();
  }
}

/// Currently selected child, derived from settings + children list.
final selectedChildProvider = Provider<AsyncValue<Child?>>((ref) {
  final childrenAsync = ref.watch(childrenListProvider);
  final settingsAsync = ref.watch(settingsControllerProvider);

  return childrenAsync.when(
    loading: () => const AsyncLoading(),
    error: AsyncError.new,
    data: (children) {
      final settings = settingsAsync.valueOrNull;
      if (children.isEmpty) return const AsyncData(null);

      final selectedId = settings?.selectedChildId;
      Child? selected;
      if (selectedId != null) {
        for (final child in children) {
          if (child.id == selectedId) {
            selected = child;
            break;
          }
        }
      }
      selected ??= children.first;

      // Persist default selection when missing/stale.
      if (settings != null && settings.selectedChildId != selected.id) {
        Future.microtask(() {
          ref
              .read(settingsControllerProvider.notifier)
              .setSelectedChildId(selected!.id);
        });
      }

      return AsyncData(selected);
    },
  );
});

final childByIdProvider = FutureProvider.family<Child?, String>((ref, id) {
  return ref.watch(childrenRepositoryProvider).getById(id);
});
