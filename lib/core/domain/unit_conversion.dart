import 'package:shishur_dinlipi/core/settings/app_settings.dart';

/// Canonical storage is always cm / kg. UI converts for display & input.
abstract final class UnitConversion {
  static const cmPerInch = 2.54;
  static const inchesPerFoot = 12.0;
  static const lbPerKg = 2.2046226218;

  static double cmToInches(double cm) => cm / cmPerInch;

  static double inchesToCm(double inches) => inches * cmPerInch;

  static ({int feet, double inches}) cmToFeetInches(double cm) {
    final totalInches = cmToInches(cm);
    final feet = totalInches ~/ inchesPerFoot;
    final inches = totalInches - (feet * inchesPerFoot);
    return (feet: feet, inches: _round1(inches));
  }

  static double feetInchesToCm({required int feet, required double inches}) {
    return inchesToCm((feet * inchesPerFoot) + inches);
  }

  static double kgToLb(double kg) => kg * lbPerKg;

  static double lbToKg(double lb) => lb / lbPerKg;

  static double roundDisplay(double value) => _round1(value);

  static double _round1(double value) => (value * 10).roundToDouble() / 10;

  /// Format height for UI using preferred unit.
  static String formatHeight({
    required double? heightCm,
    required HeightUnit unit,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (heightCm == null) return '—';
    if (unit == HeightUnit.cm) {
      final n = _num(_round1(heightCm), useBengaliDigits);
      return bangla ? '$n সেমি' : '$n cm';
    }
    final fi = cmToFeetInches(heightCm);
    final f = _num(fi.feet.toDouble(), useBengaliDigits, decimals: 0);
    final i = _num(fi.inches, useBengaliDigits);
    return bangla ? '$f ফুট $i ইঞ্চি' : "$f' $i\"";
  }

  static String formatWeight({
    required double? weightKg,
    required WeightUnit unit,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (weightKg == null) return '—';
    if (unit == WeightUnit.kg) {
      final n = _num(_round1(weightKg), useBengaliDigits);
      return bangla ? '$n কেজি' : '$n kg';
    }
    final n = _num(_round1(kgToLb(weightKg)), useBengaliDigits);
    return bangla ? '$n পাউন্ড' : '$n lb';
  }

  static String formatDeltaHeight({
    required double? deltaCm,
    required HeightUnit unit,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (deltaCm == null) return '';
    final sign = deltaCm > 0 ? '+' : '';
    if (unit == HeightUnit.cm) {
      final n = _num(_round1(deltaCm), useBengaliDigits);
      return bangla ? '$sign$n সেমি' : '$sign$n cm';
    }
    final inches = _round1(cmToInches(deltaCm));
    final n = _num(inches, useBengaliDigits);
    return bangla ? '$sign$n ইঞ্চি' : '$sign$n in';
  }

  static String formatDeltaWeight({
    required double? deltaKg,
    required WeightUnit unit,
    required bool bangla,
    bool useBengaliDigits = false,
  }) {
    if (deltaKg == null) return '';
    final sign = deltaKg > 0 ? '+' : '';
    if (unit == WeightUnit.kg) {
      final n = _num(_round1(deltaKg), useBengaliDigits);
      return bangla ? '$sign$n কেজি' : '$sign$n kg';
    }
    final n = _num(_round1(kgToLb(deltaKg)), useBengaliDigits);
    return bangla ? '$sign$n পাউন্ড' : '$sign$n lb';
  }

  static const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

  static String _num(double value, bool useBengaliDigits, {int decimals = 1}) {
    final raw = decimals == 0
        ? value.round().toString()
        : value.toStringAsFixed(decimals);
    if (!useBengaliDigits) return raw;
    return raw.split('').map((c) {
      final d = int.tryParse(c);
      return d == null ? c : _bnDigits[d];
    }).join();
  }
}
