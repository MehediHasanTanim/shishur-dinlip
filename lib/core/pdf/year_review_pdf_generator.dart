import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_font_loader.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_theme.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

typedef PdfProgressCallback = void Function(PdfGenerationProgress progress);

class PdfGenerationToken {
  bool _cancelled = false;

  void cancel() => _cancelled = true;

  bool get isCancelled => _cancelled;

  void throwIfCancelled() {
    if (_cancelled) {
      throw const PdfGenerationFailure(message: 'PDF generation was cancelled.');
    }
  }
}

/// Offline Year in Review PDF pipeline.
class YearReviewPdfGenerator extends RepositoryBase {
  YearReviewPdfGenerator(super.db, {required this.storage});

  final FileStorageService storage;

  static const _maxImageEdge = 1200;
  static const _jpegQuality = 82;
  static const exportType = 'year_in_review_pdf';

  Future<GeneratedPdfResult> generate({
    required YearReviewDraft draft,
    PdfProgressCallback? onProgress,
    PdfGenerationToken? token,
  }) {
    return guard(() async {
      final cancel = token ?? PdfGenerationToken();
      void report(PdfGenerationStage stage, double fraction, [String? message]) {
        onProgress?.call(
          PdfGenerationProgress(
            stage: stage,
            fraction: fraction,
            message: message,
          ),
        );
      }

      try {
        report(PdfGenerationStage.preparingMemories, 0.05);
        cancel.throwIfCancelled();

        final theme = PdfThemeEngine.resolve(draft.theme);
        final fonts = await PdfFontLoader.load();
        final isBn = draft.languageCode == 'bn';
        final title = isBn ? draft.displayTitleBn : draft.displayTitle;
        final included = draft.includedItems();

        report(PdfGenerationStage.processingPhotos, 0.15);
        cancel.throwIfCancelled();

        final imageBytes = <String, Uint8List>{};
        final photoItems = included
            .where((i) => i.mediaAssetId != null)
            .toList();
        for (var i = 0; i < photoItems.length; i++) {
          cancel.throwIfCancelled();
          final item = photoItems[i];
          final bytes = await _optimizeImage(item.mediaAssetId!);
          if (bytes != null) {
            imageBytes[item.mediaAssetId!] = bytes;
          }
          final frac = 0.15 + (0.35 * ((i + 1) / (photoItems.length + 1)));
          report(PdfGenerationStage.processingPhotos, frac);
        }

        if (draft.coverAssetId != null &&
            !imageBytes.containsKey(draft.coverAssetId)) {
          final cover = await _optimizeImage(draft.coverAssetId!);
          if (cover != null) imageBytes[draft.coverAssetId!] = cover;
        }

        report(PdfGenerationStage.buildingPages, 0.55);
        cancel.throwIfCancelled();

        final doc = pw.Document();
        final textStyle = pw.TextStyle(
          font: fonts.primary,
          fontFallback: fonts.fallback,
        );
        var pageEstimate = 1;

        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0),
            build: (context) => _buildCover(
              draft: draft,
              title: title,
              theme: theme,
              textStyle: textStyle,
              coverBytes: draft.coverAssetId == null
                  ? null
                  : imageBytes[draft.coverAssetId!],
              isBn: isBn,
            ),
          ),
        );

        final sections = _sectionOrder(draft);
        for (final section in sections) {
          cancel.throwIfCancelled();
          final items = draft.includedItems(section);
          if (items.isEmpty && section != YearReviewSection.parentLetter) {
            continue;
          }
          if (section == YearReviewSection.parentLetter) {
            final letter = draft.parentLetter?.trim();
            if (letter == null || letter.isEmpty) continue;
          }

          doc.addPage(
            pw.MultiPage(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.fromLTRB(36, 40, 36, 40),
              build: (context) => [
                _sectionHeader(section, theme, textStyle, isBn),
                if (section == YearReviewSection.parentLetter)
                  _parentLetterBody(draft.parentLetter!, theme, textStyle)
                else if (section == YearReviewSection.growth)
                  _growthBody(draft.growth, theme, textStyle, isBn)
                else
                  ...items.map(
                    (item) => _itemBlock(
                      item: item,
                      theme: theme,
                      textStyle: textStyle,
                      imageBytes: item.mediaAssetId == null
                          ? null
                          : imageBytes[item.mediaAssetId!],
                    ),
                  ),
              ],
            ),
          );
          pageEstimate += 1;
          report(PdfGenerationStage.buildingPages, 0.7);
        }

        report(PdfGenerationStage.savingPdf, 0.85);
        cancel.throwIfCancelled();

        final pdfBytes = await doc.save();
        if (pdfBytes.isEmpty) {
          throw const PdfGenerationFailure(message: 'Generated PDF was empty.');
        }

        final tempDir = await storage.tempDir();
        final exportId = ids.next();
        final tempFile = File(p.join(tempDir.path, '$exportId.pdf.tmp'));
        try {
          await tempFile.writeAsBytes(pdfBytes, flush: true);
        } on FileSystemException catch (e) {
          throw PdfGenerationFailure(
            message: 'Not enough storage to save the PDF.',
            cause: e,
          );
        }

        final length = await tempFile.length();
        if (length < 64) {
          await tempFile.delete();
          throw const PdfGenerationFailure(
            message: 'PDF validation failed.',
          );
        }

        cancel.throwIfCancelled();
        final exportsDir = await storage.pdfExportsDir();
        final fileName = '$exportId.pdf';
        final target = File(p.join(exportsDir.path, fileName));
        if (await target.exists()) await target.delete();
        await tempFile.rename(target.path);

        final relative = storage.toRelativePath(target.path);
        final nowUtc = now();
        await db.generatedExportsDao.upsert(
          GeneratedExportsCompanion.insert(
            id: exportId,
            exportType: exportType,
            title: title,
            filePath: relative,
            createdAt: nowUtc,
            updatedAt: nowUtc,
            childId: Value(draft.childId),
            dateRangeStart: Value(draft.startDate),
            dateRangeEnd: Value(draft.endDate),
          ),
        );

        report(PdfGenerationStage.complete, 1.0);
        return GeneratedPdfResult(
          exportId: exportId,
          title: title,
          absolutePath: target.path,
          relativePath: relative,
          pageCount: pageEstimate,
          byteSize: length,
        );
      } on PdfGenerationFailure catch (e) {
        onProgress?.call(
          PdfGenerationProgress(
            stage: PdfGenerationStage.failed,
            fraction: 0,
            error: e,
            message: e.message,
          ),
        );
        rethrow;
      } on FileSystemException catch (e) {
        final failure = PdfGenerationFailure(
          message: 'Not enough storage to save the PDF.',
          cause: e,
        );
        onProgress?.call(
          PdfGenerationProgress(
            stage: PdfGenerationStage.failed,
            fraction: 0,
            error: failure,
            message: failure.message,
          ),
        );
        throw failure;
      } catch (e) {
        if (e is AppFailure) {
          onProgress?.call(
            PdfGenerationProgress(
              stage: PdfGenerationStage.failed,
              fraction: 0,
              error: e,
              message: e.message,
            ),
          );
          rethrow;
        }
        final failure = PdfGenerationFailure(
          message: 'Could not generate the PDF.',
          cause: e,
        );
        onProgress?.call(
          PdfGenerationProgress(
            stage: PdfGenerationStage.failed,
            fraction: 0,
            error: failure,
            message: failure.message,
          ),
        );
        throw failure;
      }
    }, operation: 'yearReview.generatePdf');
  }

  Future<Uint8List?> _optimizeImage(String mediaAssetId) async {
    final row = await db.mediaAssetsDao.getById(mediaAssetId);
    if (row == null || row.deletedAt != null) return null;
    try {
      final path = row.thumbnailPath ?? row.localPath;
      final file = await storage.absoluteFile(path);
      if (!await file.exists()) return null;
      final raw = await file.readAsBytes();
      final decoded = img.decodeImage(raw);
      if (decoded == null) return Uint8List.fromList(raw);
      var image = decoded;
      final maxEdge = image.width > image.height ? image.width : image.height;
      if (maxEdge > _maxImageEdge) {
        image = img.copyResize(
          image,
          width: image.width >= image.height ? _maxImageEdge : null,
          height: image.height > image.width ? _maxImageEdge : null,
          interpolation: img.Interpolation.average,
        );
      }
      return Uint8List.fromList(
        img.encodeJpg(image, quality: _jpegQuality),
      );
    } catch (_) {
      return null;
    }
  }

  List<YearReviewSection> _sectionOrder(YearReviewDraft draft) {
    return [
      YearReviewSection.growth,
      YearReviewSection.birthday,
      YearReviewSection.milestones,
      YearReviewSection.achievements,
      YearReviewSection.funnyMoments,
      YearReviewSection.school,
      YearReviewSection.photos,
      YearReviewSection.journals,
      if (draft.includeHealth) YearReviewSection.health,
      YearReviewSection.parentLetter,
    ];
  }

  pw.Widget _buildCover({
    required YearReviewDraft draft,
    required String title,
    required PdfThemeStyle theme,
    required pw.TextStyle textStyle,
    required Uint8List? coverBytes,
    required bool isBn,
  }) {
    final subtitle = isBn
        ? '${draft.year} · ${draft.ageAtEnd} বছর'
        : '${draft.year} · Age ${draft.ageAtEnd}';

    return pw.Container(
      decoration: pw.BoxDecoration(color: theme.colors.coverBackground),
      padding: const pw.EdgeInsets.all(40),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          if (theme.showDecorDots)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                _dot(theme.colors.accent),
                pw.SizedBox(width: 8),
                _dot(PdfColors.white),
                pw.SizedBox(width: 8),
                _dot(theme.colors.accent),
              ],
            ),
          pw.Spacer(),
          if (coverBytes != null)
            pw.Center(
              child: pw.ClipRRect(
                horizontalRadius: theme.coverRadius,
                verticalRadius: theme.coverRadius,
                child: pw.Image(
                  pw.MemoryImage(coverBytes),
                  height: 220,
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
          if (coverBytes != null) pw.SizedBox(height: 28),
          pw.Text(
            title,
            style: textStyle.copyWith(
              color: PdfColors.white,
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 12),
          if (theme.elegantRules)
            pw.Center(
              child: pw.Container(
                width: 80,
                height: 1,
                color: PdfColors.white,
              ),
            ),
          if (theme.elegantRules) pw.SizedBox(height: 12),
          pw.Text(
            subtitle,
            style: textStyle.copyWith(
              color: PdfColors.white,
              fontSize: 16,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Spacer(),
          pw.Text(
            isBn ? 'শিশুর দিনলিপি' : 'Shishur Dinlipi',
            style: textStyle.copyWith(
              color: PdfColors.white,
              fontSize: 12,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget _dot(PdfColor color) => pw.Container(
    width: 10,
    height: 10,
    decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
  );

  pw.Widget _sectionHeader(
    YearReviewSection section,
    PdfThemeStyle theme,
    pw.TextStyle textStyle,
    bool isBn,
  ) {
    final label = _sectionLabel(section, isBn);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: textStyle.copyWith(
            color: theme.colors.primary,
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          height: 2,
          width: 48,
          color: theme.colors.accent,
        ),
        pw.SizedBox(height: theme.sectionSpacing),
      ],
    );
  }

  String _sectionLabel(YearReviewSection section, bool isBn) {
    if (isBn) {
      return switch (section) {
        YearReviewSection.growth => 'বৃদ্ধি',
        YearReviewSection.milestones => 'মাইলস্টোন',
        YearReviewSection.school => 'স্কুল',
        YearReviewSection.achievements => 'অর্জন',
        YearReviewSection.funnyMoments => 'মজার মুহূর্ত',
        YearReviewSection.photos => 'প্রিয় ছবি',
        YearReviewSection.birthday => 'জন্মদিন',
        YearReviewSection.journals => 'স্মৃতি',
        YearReviewSection.health => 'স্বাস্থ্য',
        YearReviewSection.parentLetter => 'বাবা-মার চিঠি',
      };
    }
    return switch (section) {
      YearReviewSection.growth => 'Growth',
      YearReviewSection.milestones => 'Milestones',
      YearReviewSection.school => 'School',
      YearReviewSection.achievements => 'Achievements',
      YearReviewSection.funnyMoments => 'Funny moments',
      YearReviewSection.photos => 'Favorite photos',
      YearReviewSection.birthday => 'Birthday',
      YearReviewSection.journals => 'Journal highlights',
      YearReviewSection.health => 'Health',
      YearReviewSection.parentLetter => 'A letter from parents',
    };
  }

  pw.Widget _parentLetterBody(
    String letter,
    PdfThemeStyle theme,
    pw.TextStyle textStyle,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: theme.colors.surface,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: theme.colors.accent, width: 0.5),
      ),
      child: pw.Text(
        letter,
        style: textStyle.copyWith(
          color: theme.colors.onSurface,
          fontSize: 13,
          lineSpacing: 4,
        ),
      ),
    );
  }

  pw.Widget _growthBody(
    GrowthSummary growth,
    PdfThemeStyle theme,
    pw.TextStyle textStyle,
    bool isBn,
  ) {
    final lines = <String>[];
    if (growth.firstHeightCm != null && growth.lastHeightCm != null) {
      lines.add(
        isBn
            ? 'উচ্চতা: ${growth.firstHeightCm!.toStringAsFixed(1)} -> ${growth.lastHeightCm!.toStringAsFixed(1)} সেমি'
            : 'Height: ${growth.firstHeightCm!.toStringAsFixed(1)} -> ${growth.lastHeightCm!.toStringAsFixed(1)} cm',
      );
    }
    if (growth.firstWeightKg != null && growth.lastWeightKg != null) {
      lines.add(
        isBn
            ? 'ওজন: ${growth.firstWeightKg!.toStringAsFixed(1)} -> ${growth.lastWeightKg!.toStringAsFixed(1)} কেজি'
            : 'Weight: ${growth.firstWeightKg!.toStringAsFixed(1)} -> ${growth.lastWeightKg!.toStringAsFixed(1)} kg',
      );
    }
    lines.add(
      isBn
          ? '${growth.measurementCount}টি পরিমাপ'
          : '${growth.measurementCount} measurements',
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines
          .map(
            (line) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                line,
                style: textStyle.copyWith(
                  color: theme.colors.onSurface,
                  fontSize: 13,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _itemBlock({
    required YearReviewItem item,
    required PdfThemeStyle theme,
    required pw.TextStyle textStyle,
    required Uint8List? imageBytes,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: theme.colors.surface,
        borderRadius: pw.BorderRadius.circular(theme.photoRadius),
        border: pw.Border.all(
          color: PdfColor.fromInt(0xFFE5E7EB),
          width: 0.4,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (imageBytes != null) ...[
            pw.ClipRRect(
              horizontalRadius: theme.photoRadius,
              verticalRadius: theme.photoRadius,
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                height: 160,
                fit: pw.BoxFit.cover,
              ),
            ),
            pw.SizedBox(height: 8),
          ],
          pw.Text(
            item.title,
            style: textStyle.copyWith(
              color: theme.colors.onSurface,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if ((item.caption ?? item.subtitle)?.trim().isNotEmpty == true) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              (item.caption ?? item.subtitle)!.trim(),
              style: textStyle.copyWith(
                color: theme.colors.muted,
                fontSize: 11,
              ),
            ),
          ],
          pw.SizedBox(height: 4),
          pw.Text(
            _formatDate(item.eventDate),
            style: textStyle.copyWith(
              color: theme.colors.muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}
