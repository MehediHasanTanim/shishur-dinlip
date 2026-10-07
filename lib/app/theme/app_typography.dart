import 'package:flutter/material.dart';

/// Typography scale from the UI spec, with generous line height for বাংলা.
abstract final class AppTypography {
  static const String? fontFamily = null;

  /// Prefer readable Latin + Bengali fallbacks on device fonts.
  static const List<String> fontFamilyFallback = [
    'Noto Sans Bengali',
    'Hind Siliguri',
    'Roboto',
    'SF Pro Text',
  ];

  static TextTheme textTheme(ColorScheme scheme) {
    final base = ThemeData(useMaterial3: true, brightness: scheme.brightness)
        .textTheme
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        );

    TextStyle scale(TextStyle? style, {double? size, FontWeight? weight}) {
      return (style ?? const TextStyle()).copyWith(
        fontSize: size,
        fontWeight: weight,
        height: 1.35,
        letterSpacing: 0,
      );
    }

    return base.copyWith(
      displayLarge: scale(base.displayLarge, size: 32, weight: FontWeight.bold),
      displayMedium: scale(
        base.displayMedium,
        size: 28,
        weight: FontWeight.bold,
      ),
      headlineLarge: scale(
        base.headlineLarge,
        size: 24,
        weight: FontWeight.w700,
      ),
      headlineMedium: scale(
        base.headlineMedium,
        size: 20,
        weight: FontWeight.w600,
      ),
      titleLarge: scale(base.titleLarge, size: 18, weight: FontWeight.w600),
      titleMedium: scale(base.titleMedium, size: 16, weight: FontWeight.w600),
      bodyLarge: scale(base.bodyLarge, size: 16, weight: FontWeight.w400),
      bodyMedium: scale(base.bodyMedium, size: 14, weight: FontWeight.w400),
      bodySmall: scale(base.bodySmall, size: 13, weight: FontWeight.w400),
      labelLarge: scale(base.labelLarge, size: 14, weight: FontWeight.w600),
      labelMedium: scale(base.labelMedium, size: 12, weight: FontWeight.w500),
      labelSmall: scale(base.labelSmall, size: 12, weight: FontWeight.w500),
    );
  }
}
