import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OcrScriptPicker extends ConsumerWidget {
  const OcrScriptPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(ocrScriptProvider);
    final isBn = Localizations.localeOf(context).languageCode == 'bn';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.ocrScriptLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final script in TextRecognitionScript.values)
              ChoiceChip(
                label: Text(_label(l10n, script)),
                selected: selected == script,
                onSelected: (_) =>
                    ref.read(ocrScriptProvider.notifier).state = script,
              ),
          ],
        ),
        if (isBn) ...[
          const SizedBox(height: 12),
          Text(
            l10n.ocrBanglaLimitation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  String _label(AppLocalizations l10n, TextRecognitionScript script) {
    return switch (script) {
      TextRecognitionScript.latin => l10n.ocrScriptLatin,
      TextRecognitionScript.chinese => l10n.ocrScriptChinese,
      TextRecognitionScript.devanagiri => l10n.ocrScriptDevanagari,
      TextRecognitionScript.japanese => l10n.ocrScriptJapanese,
      TextRecognitionScript.korean => l10n.ocrScriptKorean,
    };
  }
}
