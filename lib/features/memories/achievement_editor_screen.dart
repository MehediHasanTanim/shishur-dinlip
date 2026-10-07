import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/entity_types.dart';
import 'package:shishur_dinlipi/core/domain/models/achievement.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/attachment_drafts.dart';
import 'package:shishur_dinlipi/features/memories/recent_memories_provider.dart';
import 'package:shishur_dinlipi/features/memories/widgets/attachment_strip.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AchievementEditorScreen extends ConsumerStatefulWidget {
  const AchievementEditorScreen({super.key, this.achievementId});

  final String? achievementId;

  bool get isEditing => achievementId != null;

  @override
  ConsumerState<AchievementEditorScreen> createState() =>
      _AchievementEditorScreenState();
}

class _AchievementEditorScreenState
    extends ConsumerState<AchievementEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final AttachmentDraftsController _attachments;

  DateTime _eventDate = DateTime.now();
  String _category = AchievementCategories.personal;
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
    _description = TextEditingController()..addListener(_markDirty);
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
    if (widget.achievementId != null) {
      final item = await ref
          .read(achievementsRepositoryProvider)
          .getById(widget.achievementId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _title.text = item.title;
        _description.text = item.description ?? '';
        _eventDate = item.eventDate;
        _category = item.category;
        _favorite = item.isFavorite;
        await _attachments.loadExisting(
          entityType: EntityTypes.achievement,
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
            widget.isEditing ? l10n.editAchievement : l10n.addAchievement,
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
                      decoration: InputDecoration(
                        labelText: l10n.achievementTitle,
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return l10n.achievementTitleRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.achievementCategory),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final cat in [
                          AchievementCategories.school,
                          AchievementCategories.sports,
                          AchievementCategories.arts,
                          AchievementCategories.social,
                          AchievementCategories.personal,
                          AchievementCategories.other,
                        ])
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
                      controller: _description,
                      decoration: InputDecoration(
                        labelText: l10n.achievementDescription,
                      ),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.achievementAttachmentsHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    AttachmentStrip(controller: _attachments),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveAchievement),
            ),
          ),
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      AchievementCategories.school => l10n.categorySchool,
      AchievementCategories.sports => l10n.categorySports,
      AchievementCategories.arts => l10n.categoryArts,
      AchievementCategories.social => l10n.categorySocial,
      AchievementCategories.personal => l10n.categoryPersonal,
      AchievementCategories.other => l10n.categoryOther,
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
      final achievement = Achievement(
        id: _loadedId ?? '',
        childId: child.id,
        title: _title.text.trim(),
        category: _category,
        eventDate: DateTime(
          _eventDate.year,
          _eventDate.month,
          _eventDate.day,
        ),
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
        isFavorite: _favorite,
        createdAt: _createdAt ?? now,
        updatedAt: now,
      );
      await ref.read(achievementsRepositoryProvider).save(
            achievement: achievement,
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
