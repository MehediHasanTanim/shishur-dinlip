import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/journal_entry.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/features/tags/widgets/tag_editor.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({
    super.key,
    this.entryId,
    this.template,
  });

  final String? entryId;
  final JournalTemplate? template;

  bool get isEditing => entryId != null;

  @override
  ConsumerState<JournalEditorScreen> createState() =>
      _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final TextEditingController _location;
  late final AttachmentDraftsController _attachments;

  DateTime _eventDate = DateTime.now();
  String _entryType = JournalEntryTypes.memory;
  String? _mood;
  List<String> _tagNames = const [];
  bool _favorite = false;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _body = TextEditingController();
    _location = TextEditingController();
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    );
    _attachments.addListener(_markDirty);

    final template = widget.template;
    if (template != null) {
      _entryType = template.entryType;
      _favorite = template.startFavorite;
    }

    _title.addListener(_markDirty);
    _body.addListener(_markDirty);
    _location.addListener(_markDirty);

    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    final l10n = AppLocalizations.of(context);
    final template = widget.template;
    if (template != null && !widget.isEditing) {
      _title.text = _templateTitle(l10n, template);
    }

    if (widget.entryId != null) {
      final entry = await ref
          .read(journalRepositoryProvider)
          .getById(widget.entryId!);
      if (entry != null && mounted) {
        _loadedId = entry.id;
        _createdAt = entry.createdAt;
        _title.text = entry.title ?? '';
        _body.text = entry.body;
        _location.text = entry.locationText ?? '';
        _tagNames = List.of(entry.tagNames);
        _eventDate = entry.eventDate;
        _entryType = entry.entryType;
        _mood = entry.mood;
        _favorite = entry.isFavorite;
        await _attachments.loadExisting(
          entityType: EntityTypes.journalEntry,
          entityId: entry.id,
        );
      }
    } else if (template?.openPhotoPicker == true) {
      try {
        await _attachments.addFromSource(ImageSource.gallery);
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  String _templateTitle(AppLocalizations l10n, JournalTemplate template) {
    return switch (template) {
      JournalTemplate.somethingFunny => l10n.templateSomethingFunny,
      JournalTemplate.somethingNew => l10n.templateSomethingNew,
      JournalTemplate.proudMoment => l10n.templateProudMoment,
      JournalTemplate.difficultDay => l10n.templateDifficultDay,
      JournalTemplate.favoriteMoment => l10n.templateFavoriteMoment,
      JournalTemplate.photoMemory => l10n.templatePhotoMemory,
    };
  }

  @override
  void dispose() {
    _attachments.removeListener(_markDirty);
    _attachments.dispose();
    _title.dispose();
    _body.dispose();
    _location.dispose();
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
            widget.isEditing ? l10n.editMemory : l10n.addMemory,
          ),
          actions: [
            IconButton(
              tooltip: l10n.favorite,
              onPressed: () {
                setState(() {
                  _favorite = !_favorite;
                  _dirty = true;
                });
              },
              icon: Icon(
                _favorite ? Icons.favorite : Icons.favorite_border,
                color: _favorite
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
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
                          lastDate: DateTime.now().add(
                            const Duration(days: 1),
                          ),
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
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _body,
                      decoration: InputDecoration(
                        labelText: l10n.memoryStory,
                        alignLabelWithHint: true,
                      ),
                      minLines: 5,
                      maxLines: 12,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty &&
                            _title.text.trim().isEmpty) {
                          return l10n.memoryStoryRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.memoryMood),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final mood in [
                          JournalMoods.happy,
                          JournalMoods.calm,
                          JournalMoods.proud,
                          JournalMoods.silly,
                          JournalMoods.tired,
                          JournalMoods.sad,
                          JournalMoods.grateful,
                        ])
                          ChoiceChip(
                            label: Text(_moodLabel(l10n, mood)),
                            selected: _mood == mood,
                            onSelected: (selected) {
                              setState(() {
                                _mood = selected ? mood : null;
                                _dirty = true;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        labelText: l10n.memoryLocation,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    TagEditor(
                      entityType: EntityTypes.journalEntry,
                      initialNames: _tagNames,
                      onChanged: (names) {
                        setState(() {
                          _tagNames = names;
                          _dirty = true;
                        });
                      },
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
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.saveMemory),
            ),
          ),
        ),
      ),
    );
  }

  String _moodLabel(AppLocalizations l10n, String mood) {
    return switch (mood) {
      JournalMoods.happy => l10n.moodHappy,
      JournalMoods.calm => l10n.moodCalm,
      JournalMoods.proud => l10n.moodProud,
      JournalMoods.silly => l10n.moodSilly,
      JournalMoods.tired => l10n.moodTired,
      JournalMoods.sad => l10n.moodSad,
      JournalMoods.grateful => l10n.moodGrateful,
      _ => mood,
    };
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noChildrenMessage)));
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final tagNames = _tagNames;

      final entry = JournalEntry(
        id: _loadedId ?? '',
        childId: child.id,
        entryType: _entryType,
        title: _title.text.trim().isEmpty ? null : _title.text.trim(),
        body: _body.text.trim(),
        eventDate: DateTime(
          _eventDate.year,
          _eventDate.month,
          _eventDate.day,
        ),
        mood: _mood,
        locationText: _location.text.trim().isEmpty
            ? null
            : _location.text.trim(),
        isFavorite: _favorite,
        createdAt: _createdAt ?? now,
        updatedAt: now,
        tagNames: tagNames,
      );

      final saved = await ref.read(journalRepositoryProvider).save(
            entry: entry,
            tagNames: tagNames,
            attachments: _attachments.drafts,
          );

      ref.invalidate(recentMemoriesProvider);
      if (!mounted) return;
      setState(() => _dirty = false);
      context.pop(saved.id);
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
