import 'package:shishur_dinlipi/core/domain/date_precision.dart';

/// Localized display for approximate historical dates.
abstract final class ApproximateDateFormatter {
  static const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  static const _enMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const _bnMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  static String format({
    required DateTime? date,
    required DatePrecision precision,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (precision == DatePrecision.unknown || date == null) {
      return bangla ? 'তারিখ অজানা' : 'Date unknown';
    }

    final month = bangla ? _bnMonths[date.month - 1] : _enMonths[date.month - 1];
    final year = _digits('${date.year}', useBengaliDigits);
    final day = _digits('${date.day}', useBengaliDigits);
    final monthYear = '$month $year';
    final full = bangla ? '$day $month, $year' : '$month $day, $year';

    return switch (precision) {
      DatePrecision.exact => full,
      DatePrecision.month => monthYear,
      DatePrecision.year => year,
      DatePrecision.approximate => bangla
          ? 'প্রায় $monthYear'
          : 'Around $monthYear',
      DatePrecision.unknown => bangla ? 'তারিখ অজানা' : 'Date unknown',
    };
  }

  static String _digits(String text, bool useBengaliDigits) {
    if (!useBengaliDigits) return text;
    return text.split('').map((c) {
      final d = int.tryParse(c);
      return d == null ? c : _bnDigits[d];
    }).join();
  }
}
