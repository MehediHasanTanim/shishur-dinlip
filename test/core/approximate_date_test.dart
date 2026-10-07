import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';

void main() {
  test('unknown and null show unknown label', () {
    expect(
      ApproximateDateFormatter.format(
        date: null,
        precision: DatePrecision.unknown,
        bangla: false,
      ),
      'Date unknown',
    );
    expect(
      ApproximateDateFormatter.format(
        date: null,
        precision: DatePrecision.exact,
        bangla: true,
      ),
      'তারিখ অজানা',
    );
  });

  test('approximate wraps month', () {
    final text = ApproximateDateFormatter.format(
      date: DateTime(2023, 3, 15),
      precision: DatePrecision.approximate,
      bangla: false,
    );
    expect(text.toLowerCase(), contains('around'));
    expect(text, contains('2023'));
  });

  test('precision normalize', () {
    expect(
      DatePrecision.month.normalize(DateTime(2022, 5, 18)),
      DateTime(2022, 5, 1),
    );
    expect(
      DatePrecision.year.normalize(DateTime(2021, 8, 9)),
      DateTime(2021, 1, 1),
    );
    expect(DatePrecision.unknown.normalize(DateTime(2020, 1, 1)), isNull);
  });
}
