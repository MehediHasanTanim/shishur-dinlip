import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/school_event.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolEventEditorScreen extends ConsumerStatefulWidget {
  const SchoolEventEditorScreen({
    super.key,
    this.eventId,
    this.initialSchoolProfileId,
    this.initialEventType,
  });

  final String? eventId;
  final String? initialSchoolProfileId;
  final String? initialEventType;

  @override
  ConsumerState<SchoolEventEditorScreen> createState() =>
      _SchoolEventEditorScreenState();
}

class _SchoolEventEditorScreenState
    extends ConsumerState<SchoolEventEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final AttachmentDraftsController _attachments;

  String _eventType = SchoolEventTypes.custom;
  String? _schoolProfileId;
  DateTime _eventDate = DateTime.now();
  List<SchoolProfile> _profiles = const [];
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    _description = TextEditingController()..addListener(_markDirty);
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    )..addListener(_markDirty);
    _schoolProfileId = widget.initialSchoolProfileId;
    if (widget.initialEventType != null) {
      _eventType = widget.initialEventType!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    final l10n = AppLocalizations.of(context);
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child != null) {
      _profiles = await ref
          .read(schoolProfilesRepositoryProvider)
          .forChild(child.id);
      if (!mounted) return;
      _schoolProfileId ??= _profiles
          .where((p) => p.isCurrent)
          .map((p) => p.id)
          .firstOrNull;
    }

    if (widget.eventId != null) {
      final event = await ref
          .read(schoolEventsRepositoryProvider)
          .getById(widget.eventId!);
      if (event != null && mounted) {
        _loadedId = event.id;
        _createdAt = event.createdAt;
        _title.text = event.title;
        _description.text = event.description ?? '';
        _eventType = event.eventType;
        _eventDate = event.eventDate;
        _schoolProfileId = event.schoolProfileId;
        await _attachments.loadExisting(
          entityType: EntityTypes.schoolEvent,
          entityId: event.id,
        );
      }
    } else if (mounted) {
      _title.text = _defaultTitle(l10n, _eventType);
    }

    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  String _defaultTitle(AppLocalizations l10n, String type) {
    return switch (type) {
      SchoolEventTypes.firstDay => l10n.schoolEventFirstDay,
      SchoolEventTypes.exam => l10n.schoolEventExam,
      SchoolEventTypes.performance => l10n.schoolEventPerformance,
      SchoolEventTypes.sports => l10n.schoolEventSports,
      SchoolEventTypes.certificate => l10n.schoolEventCertificate,
      SchoolEventTypes.classPromotion => l10n.schoolEventPromotion,
      SchoolEventTypes.project => l10n.schoolEventProject,
      SchoolEventTypes.reportCard => l10n.schoolEventReportCard,
      _ => l10n.schoolEventCustom,
    };
  }

  @override
  void dispose() {
    _attachments
      ..removeListener(_markDirty)
      ..dispose();
    _title.dispose();
    _description.dispose();
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
            widget.eventId == null ? l10n.addSchoolEvent : l10n.editSchoolEvent,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    Text(l10n.schoolEventType),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in SchoolEventTypes.all)
                          ChoiceChip(
                            label: Text(_defaultTitle(l10n, type)),
                            selected: _eventType == type,
                            onSelected: (_) => setState(() {
                              _eventType = type;
                              if (_title.text.trim().isEmpty ||
                                  SchoolEventTypes.all.any(
                                    (t) =>
                                        _title.text == _defaultTitle(l10n, t),
                                  )) {
                                _title.text = _defaultTitle(l10n, type);
                              }
                              _dirty = true;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_profiles.isNotEmpty)
                      DropdownButtonFormField<String?>(
                        // ignore: deprecated_member_use
                        value: _schoolProfileId,
                        decoration: InputDecoration(
                          labelText: l10n.schoolLinkedProfile,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.schoolNoLinkedProfile),
                          ),
                          for (final profile in _profiles)
                            DropdownMenuItem(
                              value: profile.id,
                              child: Text(profile.schoolName),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          _schoolProfileId = value;
                          _dirty = true;
                        }),
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.memoryTitle,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.schoolEventTitleRequired
                          : null,
                    ),
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
                            const Duration(days: 365 * 2),
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
                      controller: _description,
                      decoration: InputDecoration(
                        labelText: l10n.memoryStory,
                      ),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.schoolAttachmentsHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    AttachmentStrip(
                      controller: _attachments,
                      allowDocuments: true,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveSchoolEvent),
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
      await ref.read(schoolEventsRepositoryProvider).save(
            event: SchoolEvent(
              id: _loadedId ?? '',
              childId: child.id,
              schoolProfileId: _schoolProfileId,
              eventType: _eventType,
              title: _title.text.trim(),
              eventDate: _eventDate,
              description: _description.text.trim().isEmpty
                  ? null
                  : _description.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            attachments: _attachments.drafts,
          );
      ref.invalidate(schoolTimelineProvider);
      ref.invalidate(recentSchoolEventProvider);
      ref.invalidate(upcomingSchoolEventsProvider);
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
