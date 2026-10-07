import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';

final timelineFilterProvider = StateProvider<TimelineFilter>(
  (ref) => TimelineFilter.all,
);

class TimelineFeedState {
  const TimelineFeedState({
    this.items = const [],
    this.hasMore = false,
    this.loading = false,
    this.loadingMore = false,
    this.error,
  });

  final List<TimelineItem> items;
  final bool hasMore;
  final bool loading;
  final bool loadingMore;
  final Object? error;

  TimelineFeedState copyWith({
    List<TimelineItem>? items,
    bool? hasMore,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool clearError = false,
  }) {
    return TimelineFeedState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class TimelineFeedNotifier extends StateNotifier<TimelineFeedState> {
  TimelineFeedNotifier(this._ref) : super(const TimelineFeedState()) {
    _ref.listen(selectedChildProvider, (_, _) => refresh());
    _ref.listen(timelineFilterProvider, (_, _) => refresh());
    refresh();
  }

  final Ref _ref;
  static const _pageSize = TimelineServicePageSize.value;

  Future<void> refresh() async {
    final child = _ref.read(selectedChildProvider).valueOrNull;
    if (child == null) {
      state = const TimelineFeedState();
      return;
    }
    state = state.copyWith(loading: true, clearError: true);
    try {
      final page = await _ref.read(timelineServiceProvider).pageForChild(
            childId: child.id,
            filter: _ref.read(timelineFilterProvider),
            offset: 0,
            limit: _pageSize,
          );
      state = TimelineFeedState(
        items: page.items,
        hasMore: page.hasMore,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error);
    }
  }

  Future<void> loadMore() async {
    if (state.loadingMore || !state.hasMore || state.loading) return;
    final child = _ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;
    state = state.copyWith(loadingMore: true, clearError: true);
    try {
      final page = await _ref.read(timelineServiceProvider).pageForChild(
            childId: child.id,
            filter: _ref.read(timelineFilterProvider),
            offset: state.items.length,
            limit: _pageSize,
          );
      state = TimelineFeedState(
        items: [...state.items, ...page.items],
        hasMore: page.hasMore,
      );
    } catch (error) {
      state = state.copyWith(loadingMore: false, error: error);
    }
  }
}

abstract final class TimelineServicePageSize {
  static const value = 40;
}

final timelineFeedProvider =
    StateNotifierProvider.autoDispose<TimelineFeedNotifier, TimelineFeedState>(
      TimelineFeedNotifier.new,
    );

final onThisDayProvider = FutureProvider.autoDispose<List<TimelineItem>>((
  ref,
) async {
  final child = ref.watch(selectedChildProvider).valueOrNull;
  if (child == null) return const [];
  return ref.watch(timelineServiceProvider).onThisDay(childId: child.id);
});

final calendarMonthProvider =
    FutureProvider.autoDispose.family<Map<DateTime, int>, DateTime>((
      ref,
      month,
    ) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return {};
      final filter = ref.watch(timelineFilterProvider);
      return ref.watch(timelineServiceProvider).monthCounts(
            childId: child.id,
            year: month.year,
            month: month.month,
            filter: filter,
          );
    });

final calendarDayProvider =
    FutureProvider.autoDispose.family<List<TimelineItem>, DateTime>((
      ref,
      day,
    ) async {
      final child = ref.watch(selectedChildProvider).valueOrNull;
      if (child == null) return const [];
      final filter = ref.watch(timelineFilterProvider);
      return ref.watch(timelineServiceProvider).forDate(
            childId: child.id,
            date: day,
            filter: filter,
          );
    });
