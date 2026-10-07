/// How precise a remembered event date is.
enum DatePrecision {
  exact,
  month,
  year,
  approximate,
  unknown;

  static DatePrecision fromStorage(String? value) {
    return DatePrecision.values.firstWhere(
      (item) => item.name == value,
      orElse: () => DatePrecision.exact,
    );
  }

  /// Normalize a picked calendar date for storage based on precision.
  DateTime? normalize(DateTime? date) {
    if (this == DatePrecision.unknown || date == null) return null;
    return switch (this) {
      DatePrecision.exact || DatePrecision.approximate => DateTime(
        date.year,
        date.month,
        date.day,
      ),
      DatePrecision.month => DateTime(date.year, date.month, 1),
      DatePrecision.year => DateTime(date.year, 1, 1),
      DatePrecision.unknown => null,
    };
  }
}
