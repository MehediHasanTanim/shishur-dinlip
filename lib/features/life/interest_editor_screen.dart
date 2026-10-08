import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/interest.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class InterestEditorScreen extends ConsumerStatefulWidget {
  const InterestEditorScreen({super.key, this.interestId});

  final String? interestId;

  @override
  ConsumerState<InterestEditorScreen> createState() =>
      _InterestEditorScreenState();
}

class _InterestEditorScreenState extends ConsumerState<InterestEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _notes;
  DateTime? _firstNoticed;
  int _level = 3;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.interestId != null) {
      final item = await ref
          .read(interestsRepositoryProvider)
          .getById(widget.interestId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _name.text = item.name;
        _notes.text = item.notes ?? '';
        _firstNoticed = item.firstNoticed;
        _level = item.interestLevel ?? 3;
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
    _name.dispose();
    _notes.dispose();
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
        appBar: AppBar(
          title: Text(
            widget.interestId == null ? l10n.addInterest : l10n.editInterest,
          ),
        ),
        body: _loading
            ? AppStateViews.loading()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(labelText: l10n.interestName),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.interestName : null,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.interestFirstNoticed),
                      subtitle: Text(
                        _firstNoticed == null
                            ? '—'
                            : MaterialLocalizations.of(context)
                                .formatMediumDate(_firstNoticed!),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _firstNoticed ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _firstNoticed = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    Text(l10n.interestLevel, style: Theme.of(context).textTheme.titleSmall),
                    Slider(
                      value: _level.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_level',
                      onChanged: (v) => setState(() {
                        _level = v.round();
                        _dirty = true;
                      }),
                    ),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.interestNotes),
                      maxLines: 3,
                    ),
                  ],
                ),
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
    if (!_formKey.currentState!.validate()) return;
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;
    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final saved = await ref.read(interestsRepositoryProvider).save(
            Interest(
              id: _loadedId ?? '',
              childId: child.id,
              name: _name.text,
              firstNoticed: _firstNoticed,
              interestLevel: _level,
              notes: _notes.text,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(interestsListProvider);
      ref.invalidate(interestDetailProvider(saved.id));
      ref.invalidate(homeLifeCardsProvider);
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
