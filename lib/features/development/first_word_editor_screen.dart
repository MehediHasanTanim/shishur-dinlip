import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/date_precision.dart';
import 'package:shishur_dinlipi/core/domain/models/first_word.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestones_overview_screen.dart';
import 'package:shishur_dinlipi/features/development/widgets/date_precision_selector.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class FirstWordEditorScreen extends ConsumerStatefulWidget {
  const FirstWordEditorScreen({super.key, this.wordId});

  final String? wordId;

  @override
  ConsumerState<FirstWordEditorScreen> createState() =>
      _FirstWordEditorScreenState();
}

class _FirstWordEditorScreenState extends ConsumerState<FirstWordEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _word;
  late final TextEditingController _language;
  late final TextEditingController _context;

  DatePrecision _precision = DatePrecision.exact;
  DateTime? _eventDate = DateTime.now();
  bool _audioPlaceholder = false;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _word = TextEditingController()..addListener(_markDirty);
    _language = TextEditingController()..addListener(_markDirty);
    _context = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.wordId != null) {
      final item = await ref
          .read(firstWordsRepositoryProvider)
          .getById(widget.wordId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _word.text = item.word;
        _language.text = item.languageCode ?? '';
        _context.text = item.contextNote ?? '';
        _precision = item.datePrecision;
        _eventDate = item.eventDate;
        _audioPlaceholder = item.audioPlaceholder;
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
    _word.dispose();
    _language.dispose();
    _context.dispose();
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
            widget.wordId == null ? l10n.addFirstWord : l10n.editFirstWord,
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
                      controller: _word,
                      decoration: InputDecoration(labelText: l10n.firstWordField),
                      textCapitalization: TextCapitalization.none,
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.firstWordRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _language,
                      decoration: InputDecoration(
                        labelText: l10n.firstWordLanguage,
                        hintText: l10n.firstWordLanguageHint,
                      ),
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
                      controller: _context,
                      decoration: InputDecoration(
                        labelText: l10n.firstWordContext,
                      ),
                      minLines: 3,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.firstWordAudioPlaceholder),
                      subtitle: Text(l10n.firstWordAudioHint),
                      value: _audioPlaceholder,
                      onChanged: (value) => setState(() {
                        _audioPlaceholder = value;
                        _dirty = true;
                      }),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveFirstWord),
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
      await ref.read(firstWordsRepositoryProvider).save(
            FirstWord(
              id: _loadedId ?? '',
              childId: child.id,
              word: _word.text.trim(),
              languageCode: _language.text.trim().isEmpty
                  ? null
                  : _language.text.trim(),
              eventDate: _eventDate,
              datePrecision: _precision,
              contextNote: _context.text.trim().isEmpty
                  ? null
                  : _context.text.trim(),
              audioPlaceholder: _audioPlaceholder,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(firstWordsListProvider);
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
