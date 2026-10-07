import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Chip-based tag editor. When [entityId] is set, add/remove persist via
/// [tagsRepositoryProvider]; otherwise tags stay local until the parent saves.
class TagEditor extends ConsumerStatefulWidget {
  const TagEditor({
    super.key,
    required this.entityType,
    this.entityId,
    this.initialNames = const [],
    this.onChanged,
  });

  final String entityType;
  final String? entityId;
  final List<String> initialNames;
  final ValueChanged<List<String>>? onChanged;

  @override
  ConsumerState<TagEditor> createState() => _TagEditorState();
}

class _TagEditorState extends ConsumerState<TagEditor> {
  final _controller = TextEditingController();
  late List<String> _tags;
  List<String> _suggestions = const [];

  @override
  void initState() {
    super.initState();
    _tags = [...widget.initialNames];
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void didUpdateWidget(covariant TagEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialNames != widget.initialNames &&
        oldWidget.entityId != widget.entityId) {
      _tags = [...widget.initialNames];
    }
  }

  Future<void> _bootstrap() async {
    final repo = ref.read(tagsRepositoryProvider);
    if (widget.entityId != null) {
      final names = await repo.namesForEntity(
        entityType: widget.entityType,
        entityId: widget.entityId!,
      );
      if (mounted && names.isNotEmpty) {
        setState(() => _tags = names);
        widget.onChanged?.call(_tags);
      }
    }
    final recent = await repo.recentNames();
    if (mounted) setState(() => _suggestions = recent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _notify() => widget.onChanged?.call(List.unmodifiable(_tags));

  Future<void> _add(String raw) async {
    final name = raw.trim();
    if (name.isEmpty) return;
    final exists = _tags.any((t) => t.toLowerCase() == name.toLowerCase());
    if (exists) {
      _controller.clear();
      return;
    }

    try {
      var added = name;
      if (widget.entityId != null) {
        added = await ref.read(tagsRepositoryProvider).addTag(
              entityType: widget.entityType,
              entityId: widget.entityId!,
              name: name,
            );
      }
      setState(() {
        _tags = [..._tags, added];
        _controller.clear();
      });
      _notify();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  Future<void> _remove(String name) async {
    try {
      if (widget.entityId != null) {
        await ref.read(tagsRepositoryProvider).removeTag(
              entityType: widget.entityType,
              entityId: widget.entityId!,
              name: name,
            );
      }
      setState(() {
        _tags = _tags.where((t) => t != name).toList();
      });
      _notify();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unusedSuggestions = _suggestions
        .where(
          (s) => !_tags.any((t) => t.toLowerCase() == s.toLowerCase()),
        )
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.tagsTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_tags.isEmpty)
          Text(
            l10n.tagsEmpty,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in _tags)
                InputChip(
                  label: Text(tag),
                  onDeleted: () => _remove(tag),
                ),
            ],
          ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: l10n.tagsAddHint,
            suffixIcon: IconButton(
              onPressed: () => _add(_controller.text),
              icon: const Icon(Icons.add),
            ),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _add,
        ),
        if (unusedSuggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final suggestion in unusedSuggestions)
                ActionChip(
                  label: Text(suggestion),
                  onPressed: () => _add(suggestion),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
