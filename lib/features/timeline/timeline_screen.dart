import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_providers.dart';
import 'package:shishur_dinlipi/features/timeline/widgets/timeline_card.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(timelineFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final feed = ref.watch(timelineFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.timelineTitle),
        actions: [
          IconButton(
            tooltip: l10n.calendarTitle,
            onPressed: () => context.push(AppRoutes.calendar),
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          const TimelineFilterChips(),
          Expanded(child: _buildBody(l10n, feed)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, TimelineFeedState feed) {
    if (feed.loading && feed.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (feed.error != null && feed.items.isEmpty) {
      return Center(child: Text(l10n.errorGeneric));
    }
    if (feed.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.timelineEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final rows = _groupByMonth(feed.items);
    final locale = Localizations.localeOf(context).toString();

    return RefreshIndicator(
      onRefresh: () => ref.read(timelineFeedProvider.notifier).refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: rows.length + (feed.hasMore || feed.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= rows.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final row = rows[index];
          if (row is _MonthHeader) {
            final label = DateFormat.yMMMM(locale).format(row.month);
            return Padding(
              padding: EdgeInsets.only(
                top: index == 0 ? 0 : 16,
                bottom: 8,
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          final item = (row as _ItemRow).item;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TimelineCard(item: item),
          );
        },
      ),
    );
  }

  List<_TimelineRow> _groupByMonth(List<TimelineItem> items) {
    final rows = <_TimelineRow>[];
    int? lastYear;
    int? lastMonth;
    for (final item in items) {
      final y = item.eventDate.year;
      final m = item.eventDate.month;
      if (y != lastYear || m != lastMonth) {
        rows.add(_MonthHeader(DateTime(y, m)));
        lastYear = y;
        lastMonth = m;
      }
      rows.add(_ItemRow(item));
    }
    return rows;
  }
}

sealed class _TimelineRow {
  const _TimelineRow();
}

class _MonthHeader extends _TimelineRow {
  const _MonthHeader(this.month);
  final DateTime month;
}

class _ItemRow extends _TimelineRow {
  const _ItemRow(this.item);
  final TimelineItem item;
}
