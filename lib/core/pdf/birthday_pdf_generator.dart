import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shishur_dinlipi/core/database/app_database.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/files/file_storage_service.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_font_loader.dart';
import 'package:shishur_dinlipi/core/repository/repository_base.dart';

/// Offline birthday memory PDF (interview + favorites snapshot).
class BirthdayPdfGenerator extends RepositoryBase {
  BirthdayPdfGenerator(super.db, {required this.storage});

  final FileStorageService storage;

  static const exportType = 'birthday_pdf';

  Future<GeneratedPdfResult> generate({
    required Birthday birthday,
    required String childName,
    required List<BirthdayAnswerComparison> comparisons,
    String languageCode = 'en',
    Map<String, String> questionLabels = const {},
  }) {
    return guard(() async {
      final fonts = await PdfFontLoader.load();
      final isBn = languageCode == 'bn';
      final title = isBn
          ? '$childName — বয়স ${birthday.age}: জন্মদিন'
          : '$childName — Age ${birthday.age}: Birthday';

      String qLabel(String key) => questionLabels[key] ?? key;

      final doc = pw.Document(
        theme: pw.ThemeData.withFont(
          base: fonts.primary,
          bold: fonts.primary,
          fontFallback: fonts.fallback,
        ),
      );

      final teal = PdfColor.fromHex('#006D5B');
      final cream = PdfColor.fromHex('#FFFBF0');

      doc.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(40),
            theme: pw.ThemeData.withFont(
              base: fonts.primary,
              bold: fonts.primary,
              fontFallback: fonts.fallback,
            ),
            buildBackground: (_) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: cream),
            ),
          ),
          build: (context) => [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: teal,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              birthday.birthdayDate.toIso8601String().split('T').first,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            if (birthday.theme != null && birthday.theme!.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                isBn ? 'থিম: ${birthday.theme}' : 'Theme: ${birthday.theme}',
              ),
            ],
            if (birthday.locationText != null &&
                birthday.locationText!.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                isBn
                    ? 'স্থান: ${birthday.locationText}'
                    : 'Location: ${birthday.locationText}',
              ),
            ],
            if (birthday.favoriteGift != null &&
                birthday.favoriteGift!.isNotEmpty) ...[
              pw.SizedBox(height: 12),
              pw.Text(
                isBn ? 'প্রিয় উপহার' : 'Favorite gift',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: teal,
                ),
              ),
              pw.Text(birthday.favoriteGift!),
            ],
            if (birthday.parentMessage != null &&
                birthday.parentMessage!.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              pw.Text(
                isBn ? 'বাবা-মার বার্তা' : 'Parent message',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: teal,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(birthday.parentMessage!),
            ],
            pw.SizedBox(height: 20),
            pw.Text(
              isBn ? 'বার্ষিক সাক্ষাৎকার' : 'Annual interview',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: teal,
              ),
            ),
            pw.SizedBox(height: 8),
            ...birthday.answers.map(
              (a) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      qLabel(a.questionKey),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(a.answer),
                  ],
                ),
              ),
            ),
            if (comparisons.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Text(
                isBn ? 'বয়স অনুযায়ী তুলনা' : 'Answers by age',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: teal,
                ),
              ),
              pw.SizedBox(height: 8),
              ...comparisons.map((c) {
                final ages = c.byAge.keys.toList()..sort();
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        qLabel(c.questionKey),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      ...ages.map(
                        (age) => pw.Text(
                          isBn
                              ? 'বয়স $age: ${c.byAge[age]}'
                              : 'Age $age: ${c.byAge[age]}',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      );

      final pdfBytes = await doc.save();
      if (pdfBytes.isEmpty) {
        throw const PdfGenerationFailure(message: 'Generated PDF was empty.');
      }

      final exportId = ids.next();
      final tempDir = await storage.tempDir();
      final tempFile = File(p.join(tempDir.path, '$exportId.pdf.tmp'));
      await tempFile.writeAsBytes(pdfBytes, flush: true);
      final exportsDir = await storage.pdfExportsDir();
      final target = File(p.join(exportsDir.path, '$exportId.pdf'));
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
          childId: Value(birthday.childId),
          dateRangeStart: Value(birthday.birthdayDate),
          dateRangeEnd: Value(birthday.birthdayDate),
        ),
      );

      return GeneratedPdfResult(
        exportId: exportId,
        title: title,
        absolutePath: target.path,
        relativePath: relative,
        pageCount: 1,
        byteSize: pdfBytes.length,
      );
    }, operation: 'birthdayPdf.generate');
  }
}
