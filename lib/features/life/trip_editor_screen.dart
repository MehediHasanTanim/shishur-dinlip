import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/trip.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/life/life_labels.dart';
import 'package:shishur_dinlipi/features/life/life_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class TripEditorScreen extends ConsumerStatefulWidget {
  const TripEditorScreen({super.key, this.tripId, this.initialType});

  final String? tripId;
  final String? initialType;

  @override
  ConsumerState<TripEditorScreen> createState() => _TripEditorScreenState();
}

class _TripEditorScreenState extends ConsumerState<TripEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _place;
  late final TextEditingController _story;
  late final TextEditingController _reaction;
  String _type = TripTypes.vacation;
  DateTime _start = DateTime.now();
  DateTime? _end;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;
  String? _albumId;
  String? _coverAssetId;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? TripTypes.vacation;
    _title = TextEditingController()..addListener(_markDirty);
    _place = TextEditingController()..addListener(_markDirty);
    _story = TextEditingController()..addListener(_markDirty);
    _reaction = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.tripId != null) {
      final item =
          await ref.read(tripsRepositoryProvider).getById(widget.tripId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _albumId = item.albumId;
        _coverAssetId = item.coverAssetId;
        _type = item.tripType;
        _title.text = item.title;
        _place.text = item.placeName;
        _story.text = item.story ?? '';
        _reaction.text = item.childReaction ?? '';
        _start = item.startDate;
        _end = item.endDate;
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
    _title.dispose();
    _place.dispose();
    _story.dispose();
    _reaction.dispose();
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
          title: Text(widget.tripId == null ? l10n.addTrip : l10n.editTrip),
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
                      value: _type,
                      decoration: InputDecoration(labelText: l10n.tripType),
                      items: [
                        for (final t in TripTypes.all)
                          DropdownMenuItem(
                            value: t,
                            child: Text(tripTypeLabel(l10n, t)),
                          ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _type = v;
                          _dirty = true;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(labelText: l10n.tripTitle),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.tripTitle : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _place,
                      decoration: InputDecoration(labelText: l10n.tripPlace),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? l10n.tripPlace : null,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.tripStartDate),
                      subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatMediumDate(_start),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _start,
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
                      title: Text(l10n.tripEndDate),
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
                          initialDate: _end ?? _start,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 366)),
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
                      controller: _story,
                      decoration: InputDecoration(labelText: l10n.tripStory),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reaction,
                      decoration: InputDecoration(labelText: l10n.tripReaction),
                      maxLines: 2,
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
      final saved = await ref.read(tripsRepositoryProvider).save(
            Trip(
              id: _loadedId ?? '',
              childId: child.id,
              tripType: _type,
              title: _title.text,
              placeName: _place.text,
              startDate: _start,
              endDate: _end,
              story: _story.text,
              childReaction: _reaction.text,
              albumId: _albumId,
              coverAssetId: _coverAssetId,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(tripsListProvider);
      ref.invalidate(tripDetailProvider(saved.id));
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
