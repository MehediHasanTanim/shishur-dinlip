import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shishur_dinlipi/core/domain/models/album.dart';

class PdfThemeColors {
  const PdfThemeColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.coverBackground,
  });

  final PdfColor primary;
  final PdfColor accent;
  final PdfColor background;
  final PdfColor surface;
  final PdfColor onSurface;
  final PdfColor muted;
  final PdfColor coverBackground;
}

class PdfThemeStyle {
  const PdfThemeStyle({
    required this.id,
    required this.colors,
    required this.coverRadius,
    required this.photoRadius,
    required this.sectionSpacing,
    required this.showDecorDots,
    required this.elegantRules,
  });

  final String id;
  final PdfThemeColors colors;
  final double coverRadius;
  final double photoRadius;
  final double sectionSpacing;
  final bool showDecorDots;
  final bool elegantRules;
}

abstract final class PdfThemeEngine {
  static PdfThemeStyle resolve(String themeId) {
    return switch (themeId) {
      AlbumThemes.playful => playful,
      AlbumThemes.colorful => colorful,
      AlbumThemes.elegant => elegant,
      _ => minimal,
    };
  }

  static const minimal = PdfThemeStyle(
    id: AlbumThemes.minimal,
    colors: PdfThemeColors(
      primary: PdfColor.fromInt(0xFF006D5B),
      accent: PdfColor.fromInt(0xFF3B82F6),
      background: PdfColor.fromInt(0xFFFFFBF0),
      surface: PdfColor.fromInt(0xFFFFFFFF),
      onSurface: PdfColor.fromInt(0xFF1F2937),
      muted: PdfColor.fromInt(0xFF6B7280),
      coverBackground: PdfColor.fromInt(0xFF006D5B),
    ),
    coverRadius: 0,
    photoRadius: 6,
    sectionSpacing: 16,
    showDecorDots: false,
    elegantRules: false,
  );

  static const playful = PdfThemeStyle(
    id: AlbumThemes.playful,
    colors: PdfThemeColors(
      primary: PdfColor.fromInt(0xFF06B6D4),
      accent: PdfColor.fromInt(0xFFF59E0B),
      background: PdfColor.fromInt(0xFFFFF8EB),
      surface: PdfColor.fromInt(0xFFFFFFFF),
      onSurface: PdfColor.fromInt(0xFF1F2937),
      muted: PdfColor.fromInt(0xFF78716C),
      coverBackground: PdfColor.fromInt(0xFF06B6D4),
    ),
    coverRadius: 18,
    photoRadius: 14,
    sectionSpacing: 18,
    showDecorDots: true,
    elegantRules: false,
  );

  static const colorful = PdfThemeStyle(
    id: AlbumThemes.colorful,
    colors: PdfThemeColors(
      primary: PdfColor.fromInt(0xFF8B5CF6),
      accent: PdfColor.fromInt(0xFFF472B6),
      background: PdfColor.fromInt(0xFFF8F5FF),
      surface: PdfColor.fromInt(0xFFFFFFFF),
      onSurface: PdfColor.fromInt(0xFF1F2937),
      muted: PdfColor.fromInt(0xFF6B7280),
      coverBackground: PdfColor.fromInt(0xFF8B5CF6),
    ),
    coverRadius: 12,
    photoRadius: 10,
    sectionSpacing: 16,
    showDecorDots: true,
    elegantRules: false,
  );

  static const elegant = PdfThemeStyle(
    id: AlbumThemes.elegant,
    colors: PdfThemeColors(
      primary: PdfColor.fromInt(0xFF1F2937),
      accent: PdfColor.fromInt(0xFF006D5B),
      background: PdfColor.fromInt(0xFFFAF7F2),
      surface: PdfColor.fromInt(0xFFFFFFFF),
      onSurface: PdfColor.fromInt(0xFF111827),
      muted: PdfColor.fromInt(0xFF6B7280),
      coverBackground: PdfColor.fromInt(0xFF1F2937),
    ),
    coverRadius: 0,
    photoRadius: 2,
    sectionSpacing: 20,
    showDecorDots: false,
    elegantRules: true,
  );

  static pw.BoxDecoration pageDecoration(PdfThemeStyle theme) {
    return pw.BoxDecoration(color: theme.colors.background);
  }
}
