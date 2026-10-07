import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/album.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/albums/albums_providers.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AlbumEditorScreen extends ConsumerStatefulWidget {
  const AlbumEditorScreen({super.key, this.albumId});

  final String? albumId;

  @override
  ConsumerState<AlbumEditorScreen> createState() => _AlbumEditorScreenState();
}

class _AlbumEditorScreenState extends ConsumerState<AlbumEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;

  String _theme = AlbumThemes.minimal;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;
  String? _coverAssetId;
  List<AlbumItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.albumId != null) {
      final album =
          await ref.read(albumsRepositoryProvider).getById(widget.albumId!);
      if (album != null && mounted) {
        _loadedId = album.id;
        _createdAt = album.createdAt;
        _title.text = album.title;
        _theme = album.theme ?? AlbumThemes.minimal;
        _coverAssetId = album.coverAssetId;
        _items = album.items;
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
            widget.albumId == null ? l10n.addAlbum : l10n.editAlbum,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.albumTitleField,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.albumTitleRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.albumTheme,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final theme in AlbumThemes.all)
                          ChoiceChip(
                            label: Text(_themeLabel(l10n, theme)),
                            selected: _theme == theme,
                            onSelected: (_) {
                              setState(() {
                                _theme = theme;
                                _dirty = true;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.image_outlined),
                      title: Text(l10n.albumCover),
                      subtitle: Text(
                        _coverAssetId == null
                            ? l10n.commonNone
                            : l10n.albumCover,
                      ),
                    ),
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
                  : Text(l10n.saveAlbum),
            ),
          ),
        ),
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, String theme) {
    return switch (theme) {
      AlbumThemes.minimal => l10n.albumThemeMinimal,
      AlbumThemes.playful => l10n.albumThemePlayful,
      AlbumThemes.colorful => l10n.albumThemeColorful,
      AlbumThemes.elegant => l10n.albumThemeElegant,
      _ => theme,
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final child = ref.read(selectedChildProvider).valueOrNull;
    if (child == null) return;

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      final saved = await ref.read(albumsRepositoryProvider).save(
            Album(
              id: _loadedId ?? '',
              childId: child.id,
              albumType: AlbumTypes.custom,
              title: _title.text.trim(),
              theme: _theme,
              coverAssetId: _coverAssetId,
              items: _items,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(customAlbumsProvider);
      ref.invalidate(albumDetailProvider(saved.id));
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
