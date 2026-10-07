import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/pdf/year_review_pdf_generator.dart';

export 'package:shishur_dinlipi/core/pdf/year_review_pdf_generator.dart'
    show PdfGenerationToken, PdfProgressCallback;

/// Offline PDF generation entry points (Year in Review, future health summary).
abstract final class PdfService {
  static const String defaultPageFormat = 'A4';

  static Future<GeneratedPdfResult> generateYearReview({
    required YearReviewPdfGenerator generator,
    required YearReviewDraft draft,
    PdfProgressCallback? onProgress,
    PdfGenerationToken? token,
  }) {
    return generator.generate(
      draft: draft,
      onProgress: onProgress,
      token: token,
    );
  }
}
