import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_labels.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class BirthdayInterviewScreen extends ConsumerStatefulWidget {
  const BirthdayInterviewScreen({super.key, required this.birthdayId});

  final String birthdayId;

  @override
  ConsumerState<BirthdayInterviewScreen> createState() =>
      _BirthdayInterviewScreenState();
}

class _BirthdayInterviewScreenState
    extends ConsumerState<BirthdayInterviewScreen> {
  final _controllers = <String, TextEditingController>{};
  bool _loading = true;
  bool _saving = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    for (final key in BirthdayInterviewQuestions.ordered) {
      _controllers[key] = TextEditingController()
        ..addListener(() {
          if (!_dirty && mounted) setState(() => _dirty = true);
        });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final birthday = await ref
        .read(birthdaysRepositoryProvider)
        .getById(widget.birthdayId);
    if (birthday != null) {
      for (final a in birthday.answers) {
        _controllers[a.questionKey]?.text = a.answer;
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await confirmDiscardIfDirty(context, isDirty: _dirty);
        if (ok && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.birthdayInterviewTitle)),
        body: _loading
            ? AppStateViews.loading()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  for (final key in BirthdayInterviewQuestions.ordered) ...[
                    TextFormField(
                      controller: _controllers[key],
                      decoration: InputDecoration(
                        labelText: birthdayQuestionLabel(l10n, key),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? l10n.stateSaveProgress : l10n.commonSave),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(birthdaysRepositoryProvider).saveInterviewAnswers(
            birthdayId: widget.birthdayId,
            answersByQuestion: {
              for (final e in _controllers.entries) e.key: e.value.text,
            },
          );
      ref.invalidate(birthdayDetailProvider(widget.birthdayId));
      ref.invalidate(birthdaysListProvider);
      ref.invalidate(birthdayCompareProvider);
      ref.invalidate(favoritesGroupedProvider);
      if (!mounted) return;
      AppStateViews.showSaveSuccess(context);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      AppStateViews.showSaveFailure(context, ErrorMapper.localize(context, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
