import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/birthday.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class BirthdayEditorScreen extends ConsumerStatefulWidget {
  const BirthdayEditorScreen({super.key, this.birthdayId});

  final String? birthdayId;

  @override
  ConsumerState<BirthdayEditorScreen> createState() =>
      _BirthdayEditorScreenState();
}

class _BirthdayEditorScreenState extends ConsumerState<BirthdayEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _age;
  late final TextEditingController _location;
  late final TextEditingController _theme;
  late final TextEditingController _gift;
  late final TextEditingController _guests;
  late final TextEditingController _parentMessage;
  late final TextEditingController _notes;

  DateTime _date = DateTime.now();
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
    _age = TextEditingController()..addListener(_markDirty);
    _location = TextEditingController()..addListener(_markDirty);
    _theme = TextEditingController()..addListener(_markDirty);
    _gift = TextEditingController()..addListener(_markDirty);
    _guests = TextEditingController()..addListener(_markDirty);
    _parentMessage = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.birthdayId != null) {
      final item = await ref
          .read(birthdaysRepositoryProvider)
          .getById(widget.birthdayId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _albumId = item.albumId;
        _coverAssetId = item.coverAssetId;
        _age.text = '${item.age}';
        _date = item.birthdayDate;
        _location.text = item.locationText ?? '';
        _theme.text = item.theme ?? '';
        _gift.text = item.favoriteGift ?? '';
        _guests.text = item.guestsText ?? '';
        _parentMessage.text = item.parentMessage ?? '';
        _notes.text = item.notes ?? '';
      }
    } else {
      final child = ref.read(selectedChildProvider).valueOrNull;
      if (child != null) {
        final years = DateTime.now().year - child.dateOfBirth.year;
        _age.text = '${years < 0 ? 0 : years}';
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
    _age.dispose();
    _location.dispose();
    _theme.dispose();
    _gift.dispose();
    _guests.dispose();
    _parentMessage.dispose();
    _notes.dispose();
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
            widget.birthdayId == null ? l10n.addBirthday : l10n.editBirthday,
          ),
        ),
        body: _loading
            ? AppStateViews.loading()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    TextFormField(
                      controller: _age,
                      decoration: InputDecoration(labelText: l10n.birthdayAge),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null) return l10n.birthdayAge;
                        if (n < 0 || n > 25) return l10n.birthdayAge;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.birthdayDate),
                      subtitle: Text(
                        MaterialLocalizations.of(context).formatFullDate(_date),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(
                            const Duration(days: 366),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _date = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayLocation,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _theme,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayTheme,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _gift,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayFavoriteGift,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _guests,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayGuests,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _parentMessage,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayParentMessage,
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(
                        labelText: l10n.birthdayNotes,
                      ),
                      maxLines: 3,
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
      final saved = await ref.read(birthdaysRepositoryProvider).save(
            Birthday(
              id: _loadedId ?? '',
              childId: child.id,
              age: int.parse(_age.text),
              birthdayDate: _date,
              locationText: _location.text,
              theme: _theme.text,
              favoriteGift: _gift.text,
              guestsText: _guests.text,
              parentMessage: _parentMessage.text,
              notes: _notes.text,
              albumId: _albumId,
              coverAssetId: _coverAssetId,
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(birthdaysListProvider);
      ref.invalidate(birthdayDetailProvider(saved.id));
      if (!mounted) return;
      AppStateViews.showSaveSuccess(context);
      context.pop(saved.id);
    } catch (e) {
      if (!mounted) return;
      AppStateViews.showSaveFailure(
        context,
        ErrorMapper.localize(context, e),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
