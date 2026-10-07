import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/domain/unit_conversion.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';

void main() {
  test('cm feet/inches round trip', () {
    final cm = UnitConversion.feetInchesToCm(feet: 3, inches: 2.5);
    final fi = UnitConversion.cmToFeetInches(cm);
    expect(fi.feet, 3);
    expect(fi.inches, closeTo(2.5, 0.05));
  });

  test('kg lb round trip', () {
    final lb = UnitConversion.kgToLb(10);
    final kg = UnitConversion.lbToKg(lb);
    expect(kg, closeTo(10, 0.001));
  });

  test('formats with bengali digits', () {
    final text = UnitConversion.formatHeight(
      heightCm: 95.5,
      unit: HeightUnit.cm,
      bangla: true,
      useBengaliDigits: true,
    );
    expect(text, contains('৯৫.৫'));
    expect(text, contains('সেমি'));
  });

  test('rejects invalid via display of null', () {
    expect(
      UnitConversion.formatWeight(
        weightKg: null,
        unit: WeightUnit.kg,
        bangla: false,
      ),
      '—',
    );
  });
}
