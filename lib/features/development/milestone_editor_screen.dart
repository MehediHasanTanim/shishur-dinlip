import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/milestone.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestone_templates.dart';
import 'package:shishur_dinlipi/features/development/milestones_overview_screen.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/features/development/widgets/date_precision_selector.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MilestoneEditorScreen extends ConsumerStatefulWidget {
  const MilestoneEditorScreen({
    super.key,
    this.milestoneId,
    this.template,
    this.initialCategory,
  });

  final String? milestoneId;
  final MilestoneTemplate? template;
  final String? initialCategory;

  @override
  ConsumerState<MilestoneEditorScreen> createState() =>
      _MilestoneEditorScreenState();
}

class _MilestoneEditorScreenState extends ConsumerState<MilestoneEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _location;
  late final TextEditingController _people;
  late final AttachmentDraftsController _attachments;

  String _category = MilestoneCategories.movement;
  DatePrecision _precision = DatePrecision.exact;
  DateTime? _eventDate = DateTime.now();
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
    _location = TextEditingController()..addListener(_markDirty);
    _people = TextEditingController()..addListener(_markDirty);
    _attachments = AttachmentDraftsController(
      attachments: ref.read(attachmentRepositoryProvider),
      storage: ref.read(fileStorageServiceProvider),
      permissions: ref.read(permissionServiceProvider),
    )..addListener(_markDirty);

    if (widget.initialCategory != null) {
      _category = widget.initialCategory!;
    }
    final template = widget.template;
    if (template != null) {
      _category = template.category;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    final l10n = AppLocalizations.of(context);
    final template = widget.template;
    if (template != null && widget.milestoneId == null) {
      _title.text = _templateTitle(l10n, template);
    }

    if (widget.milestoneId != null) {
      final item = await ref
          .read(milestonesRepositoryProvider)
          .getById(widget.milestoneId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _title.text = item.title;
        _description.text = item.description ?? '';
        _location.text = item.locationText ?? '';
        _people.text = item.peoplePresent ?? '';
        _category = item.category;
        _precision = item.datePrecision;
        _eventDate = item.eventDate;
        await _attachments.loadExisting(
          entityType: EntityTypes.milestone,
          entityId: item.id,
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

  String _templateTitle(AppLocalizations l10n, MilestoneTemplate template) {
    return switch (template) {
      MilestoneTemplate.firstCrawl => l10n.templateFirstCrawl,
      MilestoneTemplate.firstStand => l10n.templateFirstStand,
      MilestoneTemplate.firstStep => l10n.templateFirstStep,
      MilestoneTemplate.firstWalk => l10n.templateFirstWalk,
      MilestoneTemplate.firstRun => l10n.templateFirstRun,
      MilestoneTemplate.firstBicycle => l10n.templateFirstBicycle,
      MilestoneTemplate.firstWord => l10n.templateFirstWord,
      MilestoneTemplate.firstSentence => l10n.templateFirstSentence,
      MilestoneTemplate.wroteOwnName => l10n.templateWroteOwnName,
    };
  }

  @override
  void dispose() {
    _attachments
      ..removeListener(_markDirty)
      ..dispose();
    _title.dispose();
    _description.dispose();
    _location.dispose();
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
            widget.milestoneId == null
                ? l10n.addMilestone
                : l10n.editMilestone,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    Text(l10n.achievementCategory),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final cat in MilestoneCategories.all)
                          ChoiceChip(
                            label: Text(_categoryLabel(l10n, cat)),
                            selected: _category == cat,
                            onSelected: (_) => setState(() {
                              _category = cat;
                              _dirty = true;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.milestoneTitleField,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.milestoneTitleRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DatePrecisionSelector(
                      precision: _precision,
                      date: _eventDate,
                      onChanged: (precision, date) {
                        setState(() {
                          _precision = precision;
                          _eventDate = date;
                          _dirty = true;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                        labelText: l10n.memoryStory,
                      ),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        labelText: l10n.memoryLocation,
                      ),
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
              child: Text(l10n.saveMilestone),
            ),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      MilestoneCategories.movement => l10n.milestoneMovement,
      MilestoneCategories.speech => l10n.milestoneSpeech,
      MilestoneCategories.social => l10n.milestoneSocial,
      MilestoneCategories.selfCare => l10n.milestoneSelfCare,
      MilestoneCategories.learning => l10n.milestoneLearning,
      MilestoneCategories.custom => l10n.milestoneCustom,
      _ => category,
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      await ref.read(milestonesRepositoryProvider).save(
            milestone: Milestone(
              id: _loadedId ?? '',
              childId: child.id,
              category: _category,
              title: _title.text.trim(),
              eventDate: _eventDate,
              datePrecision: _precision,
              description: _description.text.trim().isEmpty
                  ? null
                  : _description.text.trim(),
              locationText: _location.text.trim().isEmpty
                  ? null
                  : _location.text.trim(),
              peoplePresent: _people.text.trim().isEmpty
                  ? null
                  : _people.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            attachments: _attachments.drafts,
          );
      ref.invalidate(recentMilestonesProvider);
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
