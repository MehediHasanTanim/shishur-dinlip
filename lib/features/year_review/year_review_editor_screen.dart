import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/domain/models/year_review.dart';
import 'package:shishur_dinlipi/core/year_review/year_review_highlight_selector.dart';
import 'package:shishur_dinlipi/features/year_review/year_review_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class YearReviewEditorScreen extends ConsumerStatefulWidget {
  const YearReviewEditorScreen({super.key, required this.year});

  final int year;

  @override
  ConsumerState<YearReviewEditorScreen> createState() =>
      _YearReviewEditorScreenState();
}

class _YearReviewEditorScreenState
    extends ConsumerState<YearReviewEditorScreen> {
  YearReviewDraft? _draft;
  final _letterController = TextEditingController();
  var _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final draft = await ref.read(yearReviewDraftProvider(widget.year).future);
      if (!mounted) return;
      _letterController.text = draft.parentLetter ?? '';
      setState(() {
        _draft = draft;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _saveAndGenerate() async {
    final draft = _draft;
    if (draft == null) return;
    final l10n = AppLocalizations.of(context);
    final withLetter = draft.copyWith(
      parentLetter: _letterController.text.trim().isEmpty
          ? null
          : _letterController.text.trim(),
      clearParentLetter: _letterController.text.trim().isEmpty,
    );
    setState(() => _draft = withLetter);

    final repo = ref.read(yearReviewPreferencesRepositoryProvider);
    final now = DateTime.now().toUtc();
    final id = withLetter.preferenceId ?? idGenerator.next();
    await repo.save(
      YearReviewPreference(
        id: id,
        childId: withLetter.childId,
        year: withLetter.year,
        parentLetter: withLetter.parentLetter,
        coverAssetId: withLetter.coverAssetId,
        theme: withLetter.theme,
        includeHealth: withLetter.includeHealth,
        languageCode: withLetter.languageCode,
        selectionJson: YearReviewDraft.encodeSelection(withLetter.items),
        titleOverride: withLetter.titleOverride,
        createdAt: now,
        updatedAt: now,
      ),
    );
    ref.invalidate(yearReviewDraftProvider(widget.year));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.yearReviewSaved)));
    context.push(AppRoutes.yearReviewGeneratePath(widget.year));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = _draft;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yearReviewEditorTitle),
        actions: [
          if (draft != null)
            TextButton(
              onPressed: _saveAndGenerate,
              child: Text(l10n.yearReviewGenerate),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(l10n.errorGeneric))
          : draft == null
          ? Center(child: Text(l10n.errorGeneric))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                Text(
                  draft.languageCode == 'bn'
                      ? draft.displayTitleBn
                      : draft.displayTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${draft.year}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.yearReviewTheme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AlbumThemes.all.map((theme) {
                    final selected = draft.theme == theme;
                    return ChoiceChip(
                      label: Text(_themeLabel(l10n, theme)),
                      selected: selected,
                      onSelected: (_) {
                        setState(
                          () => _draft = draft.copyWith(theme: theme),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.yearReviewLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'en', label: Text(l10n.settingsLanguageEnglish)),
                    ButtonSegment(value: 'bn', label: Text(l10n.settingsLanguageBangla)),
                  ],
                  selected: {draft.languageCode},
                  onSelectionChanged: (next) {
                    setState(
                      () => _draft = draft.copyWith(
                        languageCode: next.first,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.yearReviewIncludeHealth),
                  value: draft.includeHealth,
                  onChanged: (v) {
                    setState(
                      () => _draft = draft.copyWith(includeHealth: v),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.yearReviewParentLetter,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _letterController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: l10n.yearReviewParentLetterHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.yearReviewCover,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _CoverPicker(
                  draft: draft,
                  onChanged: (id) {
                    setState(
                      () => _draft = draft.copyWith(
                        coverAssetId: id,
                        clearCoverAssetId: id == null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ..._sectionBlocks(l10n, draft),
              ],
            ),
      bottomNavigationBar: draft == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: FilledButton(
                  onPressed: _saveAndGenerate,
                  child: Text(l10n.yearReviewGenerate),
                ),
              ),
            ),
    );
  }

  List<Widget> _sectionBlocks(AppLocalizations l10n, YearReviewDraft draft) {
    final widgets = <Widget>[];
    for (final section in YearReviewSection.values) {
      if (section == YearReviewSection.parentLetter) continue;
      if (section == YearReviewSection.health && !draft.includeHealth) continue;
      final items =
          draft.items.where((i) => i.section == section).toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      if (items.isEmpty) continue;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            _sectionTitle(l10n, section),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
      widgets.add(
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          // ignore: deprecated_member_use
          onReorder: (oldIndex, newIndex) {
            setState(() {
              _draft = draft.copyWith(
                items: YearReviewHighlightSelector.reorderSection(
                  items: draft.items,
                  section: section,
                  oldIndex: oldIndex,
                  newIndex: newIndex,
                ),
              );
            });
          },
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              key: ValueKey(item.id),
              child: ListTile(
                leading: Checkbox(
                  value: item.included,
                  onChanged: (v) {
                    setState(() {
                      _draft = draft.copyWith(
                        items: draft.items
                            .map(
                              (i) => i.id == item.id
                                  ? i.copyWith(included: v ?? false)
                                  : i,
                            )
                            .toList(),
                      );
                    });
                  },
                ),
                title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  item.caption ?? item.subtitle ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editCaption(item),
                ),
              ),
            );
          },
        ),
      );
    }
    return widgets;
  }

  Future<void> _editCaption(YearReviewItem item) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: item.caption ?? item.subtitle ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.yearReviewEditCaption),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || _draft == null) return;
    setState(() {
      _draft = _draft!.copyWith(
        items: _draft!.items
            .map((i) => i.id == item.id ? i.copyWith(caption: result) : i)
            .toList(),
      );
    });
  }

  String _themeLabel(AppLocalizations l10n, String theme) {
    return switch (theme) {
      AlbumThemes.playful => l10n.albumThemePlayful,
      AlbumThemes.colorful => l10n.albumThemeColorful,
      AlbumThemes.elegant => l10n.albumThemeElegant,
      _ => l10n.albumThemeMinimal,
    };
  }

  String _sectionTitle(AppLocalizations l10n, YearReviewSection section) {
    return switch (section) {
      YearReviewSection.growth => l10n.yearReviewSectionGrowth,
      YearReviewSection.milestones => l10n.yearReviewSectionMilestones,
      YearReviewSection.school => l10n.yearReviewSectionSchool,
      YearReviewSection.achievements => l10n.yearReviewSectionAchievements,
      YearReviewSection.funnyMoments => l10n.yearReviewSectionFunny,
      YearReviewSection.photos => l10n.yearReviewSectionPhotos,
      YearReviewSection.birthday => l10n.yearReviewSectionBirthday,
      YearReviewSection.journals => l10n.yearReviewSectionJournals,
      YearReviewSection.health => l10n.yearReviewSectionHealth,
      YearReviewSection.parentLetter => l10n.yearReviewParentLetter,
    };
  }
}

class _CoverPicker extends StatelessWidget {
  const _CoverPicker({required this.draft, required this.onChanged});

  final YearReviewDraft draft;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final photos = draft.items
        .where((i) => i.section == YearReviewSection.photos)
        .toList();
    if (photos.isEmpty) {
      return Text(l10n.yearReviewNoCoverPhotos);
    }
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final selected = draft.coverAssetId == null;
            return FilterChip(
              label: Text(l10n.yearReviewNoCover),
              selected: selected,
              onSelected: (_) => onChanged(null),
            );
          }
          final photo = photos[index - 1];
          final selected = draft.coverAssetId == photo.mediaAssetId;
          return FilterChip(
            label: Text(
              photo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            selected: selected,
            onSelected: (_) => onChanged(photo.mediaAssetId),
          );
        },
      ),
    );
  }
}
