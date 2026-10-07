import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/funny_moment.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class FunnyMomentEditorScreen extends ConsumerStatefulWidget {
  const FunnyMomentEditorScreen({super.key, this.momentId});

  final String? momentId;

  bool get isEditing => momentId != null;

  @override
  ConsumerState<FunnyMomentEditorScreen> createState() =>
      _FunnyMomentEditorScreenState();
}

class _FunnyMomentEditorScreenState
    extends ConsumerState<FunnyMomentEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _quote;
  late final TextEditingController _story;
  late final TextEditingController _people;
  late final AttachmentDraftsController _attachments;

  DateTime _eventDate = DateTime.now();
  bool _favorite = false;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    _quote = TextEditingController()..addListener(_markDirty);
    _story = TextEditingController()..addListener(_markDirty);
    _people = TextEditingController()..addListener(_markDirty);
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    )..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.momentId != null) {
      final moment = await ref
          .read(funnyMomentsRepositoryProvider)
          .getById(widget.momentId!);
      if (moment != null && mounted) {
        _loadedId = moment.id;
        _createdAt = moment.createdAt;
        _title.text = moment.title ?? '';
        _quote.text = moment.quoteText ?? '';
        _story.text = moment.story ?? '';
        _people.text = moment.peoplePresent ?? '';
        _eventDate = moment.eventDate;
        _favorite = moment.isFavorite;
        await _attachments.loadExisting(
          entityType: EntityTypes.funnyMoment,
          entityId: moment.id,
        );
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
    _attachments
      ..removeListener(_markDirty)
      ..dispose();
    _title.dispose();
    _quote.dispose();
    _story.dispose();
    _people.dispose();
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
            widget.isEditing ? l10n.editFunnyMoment : l10n.addFunnyMoment,
          ),
          actions: [
            IconButton(
              onPressed: () => setState(() {
                _favorite = !_favorite;
                _dirty = true;
              }),
              icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.memoryDate),
                      subtitle: Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatFullDate(_eventDate),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _eventDate,
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _eventDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(labelText: l10n.memoryTitle),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _quote,
                      decoration: InputDecoration(
                        labelText: l10n.funnyQuote,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty &&
                            _story.text.trim().isEmpty &&
                            _title.text.trim().isEmpty) {
                          return l10n.funnyContentRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _story,
                      decoration: InputDecoration(labelText: l10n.memoryStory),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _people,
                      decoration: InputDecoration(
                        labelText: l10n.peoplePresent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AttachmentStrip(controller: _attachments),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveFunnyMoment),
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
      final moment = FunnyMoment(
        id: _loadedId ?? '',
        childId: child.id,
        eventDate: DateTime(
          _eventDate.year,
          _eventDate.month,
          _eventDate.day,
        ),
        title: _title.text.trim().isEmpty ? null : _title.text.trim(),
        quoteText: _quote.text.trim().isEmpty ? null : _quote.text.trim(),
        story: _story.text.trim().isEmpty ? null : _story.text.trim(),
        peoplePresent: _people.text.trim().isEmpty
            ? null
            : _people.text.trim(),
        isFavorite: _favorite,
        createdAt: _createdAt ?? now,
        updatedAt: now,
      );
      await ref.read(funnyMomentsRepositoryProvider).save(
            moment: moment,
            attachments: _attachments.drafts,
          );
      ref.invalidate(recentMemoriesProvider);
      if (mounted) {
        setState(() => _dirty = false);
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
