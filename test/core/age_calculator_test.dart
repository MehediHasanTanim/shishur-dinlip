import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';

void main() {
  test('calculates years months and days', () {
    final age = AgeCalculator.at(
      DateTime(2020, 3, 15),
      DateTime(2025, 7, 20),
    );
    expect(age.years, 5);
    expect(age.months, 4);
    expect(age.days, 5);
  });

  test('rejects future DOB as zero age', () {
    final age = AgeCalculator.at(
      DateTime(2030, 1, 1),
      DateTime(2026, 1, 1),
    );
    expect(age.isZero, isTrue);
  });

  test('formats english and bangla', () {
    const age = AgeBreakdown(years: 5, months: 4, days: 0);
    expect(
      AgeFormatter.format(age: age, bangla: false),
      '5 years 4 months',
    );
    expect(
      AgeFormatter.format(age: age, bangla: true, useBengaliDigits: true),
      '৫ বছর ৪ মাস',
    );
  });

  test('age at event matches calendar math', () {
    final age = AgeCalculator.atEvent(
      dateOfBirth: DateTime(2018, 6, 1),
      eventDate: DateTime(2020, 6, 1),
    );
    expect(age.years, 2);
    expect(age.months, 0);
  });
}
