import 'package:flutter/material.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class DatePrecisionSelector extends StatelessWidget {
  const DatePrecisionSelector({
    super.key,
    required this.precision,
    required this.date,
    required this.onChanged,
  });

  final DatePrecision precision;
  final DateTime? date;
  final void Function(DatePrecision precision, DateTime? date) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.datePrecisionLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in DatePrecision.values)
              ChoiceChip(
                label: Text(_label(l10n, value)),
                selected: precision == value,
                onSelected: (_) {
                  if (value == DatePrecision.unknown) {
                    onChanged(value, null);
                  } else {
                    onChanged(value, date ?? DateTime.now());
                  }
                },
              ),
          ],
        ),
        if (precision != DatePrecision.unknown) ...[
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_pickerTitle(l10n)),
            subtitle: Text(
              date == null
                  ? l10n.datePrecisionPick
                  : _subtitle(context, date!),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: () => _pick(context),
          ),
        ],
      ],
    );
  }

  String _label(AppLocalizations l10n, DatePrecision value) {
    return switch (value) {
      DatePrecision.exact => l10n.datePrecisionExact,
      DatePrecision.month => l10n.datePrecisionMonth,
      DatePrecision.year => l10n.datePrecisionYear,
      DatePrecision.approximate => l10n.datePrecisionApproximate,
      DatePrecision.unknown => l10n.datePrecisionUnknown,
    };
  }

  String _pickerTitle(AppLocalizations l10n) {
    return switch (precision) {
      DatePrecision.month => l10n.datePrecisionPickMonth,
      DatePrecision.year => l10n.datePrecisionPickYear,
      _ => l10n.memoryDate,
    };
  }

  String _subtitle(BuildContext context, DateTime date) {
    final l10n = MaterialLocalizations.of(context);
    return switch (precision) {
      DatePrecision.year => '${date.year}',
      DatePrecision.month => l10n.formatMonthYear(date),
      _ => l10n.formatFullDate(date),
    };
  }

  Future<void> _pick(BuildContext context) async {
    final initial = date ?? DateTime.now();
    if (precision == DatePrecision.year) {
      final year = await showDialog<int>(
        context: context,
        builder: (context) {
          var selected = initial.year;
          return AlertDialog(
            title: Text(AppLocalizations.of(context).datePrecisionPickYear),
            content: SizedBox(
              height: 200,
              width: 120,
              child: YearPicker(
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
                selectedDate: DateTime(selected),
                onChanged: (d) {
                  selected = d.year;
                  Navigator.pop(context, selected);
                },
              ),
            ),
          );
        },
      );
      if (year != null) onChanged(precision, DateTime(year, 1, 1));
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(DateTime.now()) ? DateTime.now() : initial,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      initialDatePickerMode: precision == DatePrecision.month
          ? DatePickerMode.year
          : DatePickerMode.day,
    );
    if (picked != null) onChanged(precision, picked);
  }
}
