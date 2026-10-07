import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_labels.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class FavoriteEditorScreen extends ConsumerStatefulWidget {
  const FavoriteEditorScreen({super.key, this.favoriteId});

  final String? favoriteId;

  @override
  ConsumerState<FavoriteEditorScreen> createState() =>
      _FavoriteEditorScreenState();
}

class _FavoriteEditorScreenState extends ConsumerState<FavoriteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _value;
  late final TextEditingController _notes;

  String _category = FavoriteCategories.food;
  DateTime? _start = DateTime.now();
  DateTime? _end;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;
  int? _recordedAge;

  @override
  void initState() {
    super.initState();
    _value = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.favoriteId != null) {
      final item = await ref
          .read(favoritesRepositoryProvider)
          .getById(widget.favoriteId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _category = item.category;
        _value.text = item.value;
        _notes.text = item.notes ?? '';
        _start = item.startDate;
        _end = item.endDate;
        _recordedAge = item.recordedAge;
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
    _value.dispose();
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
            widget.favoriteId == null ? l10n.addFavorite : l10n.editFavorite,
          ),
        ),
        body: _loading
            ? AppStateViews.loading()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: _category,
                      decoration: InputDecoration(
                        labelText: l10n.favoriteCategory,
                      ),
                      items: [
                        for (final c in FavoriteCategories.all)
                          DropdownMenuItem(
                            value: c,
                            child: Text(favoriteCategoryLabel(l10n, c)),
                          ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _category = v;
                          _dirty = true;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _value,
                      decoration: InputDecoration(
                        labelText: l10n.favoriteValue,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.favoriteValue : null,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.favoriteStartDate),
                      subtitle: Text(
                        _start == null
                            ? '—'
                            : MaterialLocalizations.of(context)
                                .formatMediumDate(_start!),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _start ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (picked != null) {
                          setState(() {
                            _start = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.favoriteEndDate),
                      subtitle: Text(
                        _end == null
                            ? '—'
                            : MaterialLocalizations.of(context)
                                .formatMediumDate(_end!),
                      ),
                      trailing: _end == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setState(() {
                                _end = null;
                                _dirty = true;
                              }),
                            ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _end ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 1)),
                        );
                        if (picked != null) {
                          setState(() {
                            _end = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(
                        labelText: l10n.favoriteNotes,
                      ),
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
      await ref.read(favoritesRepositoryProvider).save(
            Favorite(
              id: _loadedId ?? '',
              childId: child.id,
              category: _category,
              value: _value.text,
              startDate: _start,
              endDate: _end,
              notes: _notes.text,
              recordedAge: _recordedAge,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
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
