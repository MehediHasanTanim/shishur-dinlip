import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

enum _QuoteTheme { warm, teal, cream }

/// UX §17.7 — quote card preview with theme / photo / age / date toggles.
class QuoteCardScreen extends ConsumerStatefulWidget {
  const QuoteCardScreen({super.key, required this.momentId});

  final String momentId;

  @override
  ConsumerState<QuoteCardScreen> createState() => _QuoteCardScreenState();
}

class _QuoteCardScreenState extends ConsumerState<QuoteCardScreen> {
  final _cardKey = GlobalKey();
  FunnyMoment? _moment;
  var _loading = true;
  var _busy = false;
  var _theme = _QuoteTheme.warm;
  var _includePhoto = true;
  var _includeAge = true;
  var _includeDate = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final moment = await ref
        .read(funnyMomentsRepositoryProvider)
        .getById(widget.momentId);
    if (mounted) {
      setState(() {
        _moment = moment;
        _loading = false;
      });
    }
  }

  Color _bgFor(_QuoteTheme theme) {
    return switch (theme) {
      _QuoteTheme.warm => const Color(0xFFFFF0E6),
      _QuoteTheme.teal => const Color(0xFFE6F4F1),
      _QuoteTheme.cream => const Color(0xFFFFFBF0),
    };
  }

  Color _accentFor(_QuoteTheme theme) {
    return switch (theme) {
      _QuoteTheme.warm => const Color(0xFFC2784A),
      _QuoteTheme.teal => const Color(0xFF006D5B),
      _QuoteTheme.cream => const Color(0xFF8B6914),
    };
  }

  Future<File?> _captureCard() async {
    final boundary =
        _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return null;
    final storage = ref.read(fileStorageServiceProvider);
    final dir = await storage.albumImagesDir();
    final name = storage.buildFileName(preferredExtension: '.png');
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await _captureCard();
      if (!mounted) return;
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quoteCardSave)),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await _captureCard();
      if (file == null || !mounted) return;
      await Share.shareXFiles([XFile(file.path)], text: l10n.quoteCardTitle);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final moment = _moment;
    if (moment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final child = ref.watch(selectedChildProvider).valueOrNull;
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final ageText = child == null
        ? null
        : AgeFormatter.format(
            age: AgeCalculator.atEvent(
              dateOfBirth: child.dateOfBirth,
              eventDate: moment.eventDate,
            ),
            bangla: bangla,
            useBengaliDigits: settings?.useBengaliDigits ?? false,
          );
    final quote = (moment.quoteText?.trim().isNotEmpty == true)
        ? moment.quoteText!.trim()
        : moment.displayTitle;
    final dateFmt = MaterialLocalizations.of(context);
    final accent = _accentFor(_theme);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quoteCardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RepaintBoundary(
            key: _cardKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bgFor(_theme),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_includePhoto && child != null) ...[
                    ChildAvatar(child: child, radius: 36),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    '"$quote"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: accent,
                          height: 1.35,
                        ),
                  ),
                  if (child != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      child.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                  if (_includeAge && ageText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      ageText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: accent.withValues(alpha: 0.85),
                          ),
                    ),
                  ],
                  if (_includeDate) ...[
                    const SizedBox(height: 4),
                    Text(
                      dateFmt.formatMediumDate(moment.eventDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: accent.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.quoteCardTheme, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.quoteCardThemeWarm),
                selected: _theme == _QuoteTheme.warm,
                onSelected: (_) => setState(() => _theme = _QuoteTheme.warm),
              ),
              ChoiceChip(
                label: Text(l10n.quoteCardThemeTeal),
                selected: _theme == _QuoteTheme.teal,
                onSelected: (_) => setState(() => _theme = _QuoteTheme.teal),
              ),
              ChoiceChip(
                label: Text(l10n.quoteCardThemeCream),
                selected: _theme == _QuoteTheme.cream,
                onSelected: (_) => setState(() => _theme = _QuoteTheme.cream),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.quoteCardIncludePhoto),
            value: _includePhoto,
            onChanged: (v) => setState(() => _includePhoto = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.quoteCardIncludeAge),
            value: _includeAge,
            onChanged: (v) => setState(() => _includeAge = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.quoteCardIncludeDate),
            value: _includeDate,
            onChanged: (v) => setState(() => _includeDate = v),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _save,
            icon: const Icon(Icons.save_alt),
            label: Text(l10n.quoteCardSave),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _share,
            icon: const Icon(Icons.ios_share),
            label: Text(l10n.quoteCardShare),
          ),
        ],
      ),
    );
  }
}
