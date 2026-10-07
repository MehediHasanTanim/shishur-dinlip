import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_providers.dart';
import 'package:shishur_dinlipi/features/timeline/widgets/timeline_card.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _month;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
      final day = _selectedDay.day.clamp(1, daysInMonth);
      _selectedDay = DateTime(_month.year, _month.month, day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final countsAsync = ref.watch(calendarMonthProvider(_month));
    final dayAsync = ref.watch(calendarDayProvider(_selectedDay));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendarTitle)),
      body: Column(
        children: [
          const TimelineFilterChips(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _shiftMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    DateFormat.yMMMM(locale).format(_month),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => _shiftMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: countsAsync.when(
              loading: () => const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => SizedBox(
                height: 80,
                child: Center(child: Text(l10n.errorGeneric)),
              ),
              data: (counts) => _MonthGrid(
                month: _month,
                selectedDay: _selectedDay,
                counts: counts,
                onSelect: (day) => setState(() => _selectedDay = day),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat.yMMMEd(locale).format(_selectedDay),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: dayAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.errorGeneric)),
              data: (items) {
                if (items.isEmpty) {
                  return Center(child: Text(l10n.calendarNoEvents));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return TimelineCard(item: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selectedDay,
    required this.counts,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Map<DateTime, int> counts;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // Mon=1
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = firstWeekday - 1; // Monday-first grid
    final totalCells = leading + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final scheme = Theme.of(context).colorScheme;
    final weekdayLabels = _weekdayLabels(context);

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(
                  child: _buildCell(
                    context,
                    index: r * 7 + c,
                    leading: leading,
                    daysInMonth: daysInMonth,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context, {
    required int index,
    required int leading,
    required int daysInMonth,
  }) {
    final dayNum = index - leading + 1;
    if (dayNum < 1 || dayNum > daysInMonth) {
      return const SizedBox(height: 44);
    }
    final day = DateTime(month.year, month.month, dayNum);
    final selected = _isSameDay(day, selectedDay);
    final count = _countFor(day);
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onSelect(day),
      child: SizedBox(
        height: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: selected
                  ? BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Text(
                '$dayNum',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? scheme.onPrimary : null,
                  fontWeight: selected ? FontWeight.w600 : null,
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: 6,
              child: count > 0
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: selected
                            ? scheme.onPrimary
                            : scheme.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  int _countFor(DateTime day) {
    for (final entry in counts.entries) {
      if (_isSameDay(entry.key, day)) return entry.value;
    }
    return 0;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<String> _weekdayLabels(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final monday = DateTime(2024, 1, 1); // was a Monday
    return List.generate(7, (i) {
      return DateFormat.E(locale).format(monday.add(Duration(days: i)));
    });
  }
}
