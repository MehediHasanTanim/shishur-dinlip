import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/domain/models/first_word.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestones_overview_screen.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class FirstWordDetailScreen extends ConsumerStatefulWidget {
  const FirstWordDetailScreen({super.key, required this.wordId});

  final String wordId;

  @override
  ConsumerState<FirstWordDetailScreen> createState() =>
      _FirstWordDetailScreenState();
}

class _FirstWordDetailScreenState extends ConsumerState<FirstWordDetailScreen> {
  FirstWord? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final item = await ref
        .read(firstWordsRepositoryProvider)
        .getById(widget.wordId);
    if (mounted) {
      setState(() {
        _item = item;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final child = ref.watch(selectedChildProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn =
        ref.watch(settingsControllerProvider).valueOrNull?.useBengaliDigits ??
        false;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final age = child == null || item.eventDate == null
        ? null
        : AgeFormatter.format(
            age: AgeCalculator.atEvent(
              dateOfBirth: child.dateOfBirth,
              eventDate: item.eventDate!,
            ),
            bangla: bangla,
            useBengaliDigits: useBn,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.firstWordDetail),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.firstWordEditPath(item.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(item),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '"${item.word}"',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ApproximateDateFormatter.format(
              date: item.eventDate,
              precision: item.datePrecision,
              bangla: bangla,
              useBengaliDigits: useBn,
            ),
          ),
          if (age != null) ...[
            const SizedBox(height: 4),
            Text(age),
          ],
          if (item.languageCode != null) ...[
            const SizedBox(height: 12),
            Text('${l10n.firstWordLanguage}: ${item.languageCode}'),
          ],
          if (item.contextNote != null) ...[
            const SizedBox(height: 16),
            Text(item.contextNote!),
          ],
          if (item.audioPlaceholder) ...[
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.mic_none),
                title: Text(l10n.firstWordAudioPlaceholder),
                subtitle: Text(l10n.firstWordAudioHint),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _delete(FirstWord item) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteFirstWordTitle),
        content: Text(l10n.deleteFirstWordMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(firstWordsRepositoryProvider).softDelete(item.id);
      ref.invalidate(firstWordsListProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
