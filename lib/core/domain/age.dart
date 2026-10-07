import 'package:flutter/foundation.dart';

/// Calendar age broken into years, months, and leftover days.
@immutable
class AgeBreakdown {
  const AgeBreakdown({
    required this.years,
    required this.months,
    required this.days,
  });

  final int years;
  final int months;
  final int days;

  bool get isZero => years == 0 && months == 0 && days == 0;
}

abstract final class AgeCalculator {
  /// Age as of [asOf] (defaults to now, local calendar date).
  static AgeBreakdown at(DateTime dateOfBirth, [DateTime? asOf]) {
    final birth = DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day);
    final point = asOf ?? DateTime.now();
    final end = DateTime(point.year, point.month, point.day);

    if (end.isBefore(birth)) {
      return const AgeBreakdown(years: 0, months: 0, days: 0);
    }

    var years = end.year - birth.year;
    var months = end.month - birth.month;
    var days = end.day - birth.day;

    if (days < 0) {
      months -= 1;
      final previousMonth = DateTime(end.year, end.month, 0);
      days += previousMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return AgeBreakdown(years: years, months: months, days: days);
  }

  static AgeBreakdown current(DateTime dateOfBirth) => at(dateOfBirth);

  static AgeBreakdown atEvent({
    required DateTime dateOfBirth,
    required DateTime eventDate,
  }) => at(dateOfBirth, eventDate);
}

/// Localized age display helpers (English / বাংলা, optional Bengali digits).
abstract final class AgeFormatter {
  static const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  static String format({
    required AgeBreakdown age,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (age.isZero) {
      return bangla ? 'জন্মের দিন' : 'Newborn';
    }

    final parts = <String>[];
    if (age.years > 0) {
      parts.add(
        bangla
            ? '${_num(age.years, useBengaliDigits)} বছর'
            : '${age.years} ${age.years == 1 ? 'year' : 'years'}',
      );
    }
    if (age.months > 0) {
      parts.add(
        bangla
            ? '${_num(age.months, useBengaliDigits)} মাস'
            : '${age.months} ${age.months == 1 ? 'month' : 'months'}',
      );
    }
    if (age.years == 0 && age.months == 0 && age.days > 0) {
      parts.add(
        bangla
            ? '${_num(age.days, useBengaliDigits)} দিন'
            : '${age.days} ${age.days == 1 ? 'day' : 'days'}',
      );
    }

    return parts.join(bangla ? ' ' : ' ');
  }

  static String _num(int value, bool useBengaliDigits) {
    if (!useBengaliDigits) return '$value';
    return value.toString().split('').map((c) {
      final d = int.tryParse(c);
      return d == null ? c : _bnDigits[d];
    }).join();
  }
}
