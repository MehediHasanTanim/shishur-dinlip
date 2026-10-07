import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/pdf/pdf_service.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class YearReviewGenerateScreen extends ConsumerStatefulWidget {
  const YearReviewGenerateScreen({super.key, required this.year});

  final int year;

  @override
  ConsumerState<YearReviewGenerateScreen> createState() =>
      _YearReviewGenerateScreenState();
}

class _YearReviewGenerateScreenState
    extends ConsumerState<YearReviewGenerateScreen> {
  PdfGenerationProgress _progress = const PdfGenerationProgress(
    stage: PdfGenerationStage.preparingMemories,
    fraction: 0,
  );
  GeneratedPdfResult? _result;
  PdfGenerationToken? _token;
  var _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _token?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    if (_started) return;
    _started = true;
    final token = PdfGenerationToken();
    _token = token;
    try {
      final draft = await ref.read(yearReviewDraftProvider(widget.year).future);
      if (!mounted) return;
      final generator = ref.read(yearReviewPdfGeneratorProvider);
      final result = await PdfService.generateYearReview(
        generator: generator,
        draft: draft,
        token: token,
        onProgress: (p) {
          if (!mounted) return;
          setState(() => _progress = p);
        },
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _progress = const PdfGenerationProgress(
          stage: PdfGenerationStage.complete,
          fraction: 1,
        );
      });
    } on PdfGenerationFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _progress = PdfGenerationProgress(
          stage: PdfGenerationStage.failed,
          fraction: 0,
          message: e.message,
          error: e,
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _progress = PdfGenerationProgress(
          stage: PdfGenerationStage.failed,
          fraction: 0,
          message: e.toString(),
          error: e,
        );
      });
    }
  }

  Future<void> _preview() async {
    final result = _result;
    if (result == null) return;
    final bytes = await File(result.absolutePath).readAsBytes();
    if (!mounted) return;
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> _share() async {
    final result = _result;
    if (result == null) return;
    await Share.shareXFiles(
      [XFile(result.absolutePath, mimeType: 'application/pdf')],
      subject: result.title,
      text: result.title,
    );
  }

  Future<void> _print() async {
    final result = _result;
    if (result == null) return;
    final bytes = await File(result.absolutePath).readAsBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final complete = _progress.stage == PdfGenerationStage.complete;
    final failed = _progress.stage == PdfGenerationStage.failed;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yearReviewGeneratingTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _token?.cancel();
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Icon(
              failed
                  ? Icons.error_outline
                  : complete
                  ? Icons.check_circle_outline
                  : Icons.auto_stories_outlined,
              size: 56,
              color: failed
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _stageLabel(l10n, _progress.stage),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (_progress.message != null && failed) ...[
              const SizedBox(height: 8),
              Text(
                _progress.message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            if (!complete && !failed)
              LinearProgressIndicator(value: _progress.fraction.clamp(0.05, 1)),
            if (complete && _result != null) ...[
              Text(
                _result!.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.yearReviewPdfReady,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _preview,
                icon: const Icon(Icons.visibility_outlined),
                label: Text(l10n.yearReviewPreview),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _share,
                icon: const Icon(Icons.ios_share),
                label: Text(l10n.yearReviewShare),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _print,
                icon: const Icon(Icons.print_outlined),
                label: Text(l10n.yearReviewPrint),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.yearReviewSavedToExports,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else if (failed) ...[
              const Spacer(),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _started = false;
                    _result = null;
                    _progress = const PdfGenerationProgress(
                      stage: PdfGenerationStage.preparingMemories,
                      fraction: 0,
                    );
                  });
                  _start();
                },
                child: Text(l10n.commonRetry),
              ),
            ] else
              const Spacer(),
          ],
        ),
      ),
    );
  }

  String _stageLabel(AppLocalizations l10n, PdfGenerationStage stage) {
    return switch (stage) {
      PdfGenerationStage.preparingMemories => l10n.yearReviewStagePreparing,
      PdfGenerationStage.processingPhotos => l10n.yearReviewStagePhotos,
      PdfGenerationStage.buildingPages => l10n.yearReviewStageBuilding,
      PdfGenerationStage.savingPdf => l10n.yearReviewStageSaving,
      PdfGenerationStage.complete => l10n.yearReviewStageComplete,
      PdfGenerationStage.failed => l10n.yearReviewStageFailed,
    };
  }
}
