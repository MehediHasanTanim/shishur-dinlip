import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontSet {
  const PdfFontSet({required this.primary, required this.fallback});

  final pw.Font primary;
  final List<pw.Font> fallback;
}

/// Loads bundled Noto fonts for offline PDF text (EN + বাংলা).
abstract final class PdfFontLoader {
  static const bengaliAssetPath = 'assets/fonts/NotoSansBengali-Regular.ttf';
  static const latinAssetPath = 'assets/fonts/NotoSans-Regular.ttf';

  static PdfFontSet? _cached;

  static Future<PdfFontSet> load() async {
    if (_cached != null) return _cached!;
    final bengaliData = await rootBundle.load(bengaliAssetPath);
    final latinData = await rootBundle.load(latinAssetPath);
    final bengali = pw.Font.ttf(bengaliData);
    final latin = pw.Font.ttf(latinData);
    // Prefer Bengali for বাংলা glyphs; fall back to Noto Sans for Latin/symbols.
    _cached = PdfFontSet(primary: bengali, fallback: [latin]);
    return _cached!;
  }

  /// Test helper to inject fonts without Flutter assets.
  static void debugSetFonts({
    required pw.Font primary,
    List<pw.Font>? fallback,
  }) {
    _cached = PdfFontSet(primary: primary, fallback: fallback ?? const []);
  }

  static void clearCache() {
    _cached = null;
  }
}
