import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolProfileEditorScreen extends ConsumerStatefulWidget {
  const SchoolProfileEditorScreen({super.key, this.profileId});

  final String? profileId;

  @override
  ConsumerState<SchoolProfileEditorScreen> createState() =>
      _SchoolProfileEditorScreenState();
}

class _SchoolProfileEditorScreenState
    extends ConsumerState<SchoolProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _className;
  late final TextEditingController _teacher;
  late final TextEditingController _notes;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController()..addListener(_markDirty);
    _className = TextEditingController()..addListener(_markDirty);
    _teacher = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.profileId != null) {
      final profile = await ref
          .read(schoolProfilesRepositoryProvider)
          .getById(widget.profileId!);
      if (profile != null && mounted) {
        _loadedId = profile.id;
        _createdAt = profile.createdAt;
        _name.text = profile.schoolName;
        _className.text = profile.className ?? '';
        _teacher.text = profile.teacherName ?? '';
        _notes.text = profile.notes ?? '';
        _startDate = profile.startDate;
        _endDate = profile.endDate;
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
    _name.dispose();
    _className.dispose();
    _teacher.dispose();
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
            widget.profileId == null
                ? l10n.addSchoolProfile
                : l10n.editSchoolProfile,
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
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: l10n.schoolName,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.schoolNameRequired
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _className,
                      decoration: InputDecoration(
                        labelText: l10n.schoolClass,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _teacher,
                      decoration: InputDecoration(
                        labelText: l10n.schoolTeacher,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.schoolStartDate),
                      subtitle: Text(
                        _startDate == null
                            ? l10n.datePrecisionPick
                            : MaterialLocalizations.of(
                                context,
                              ).formatFullDate(_startDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.schoolEndDate),
                      subtitle: Text(
                        _endDate == null
                            ? l10n.schoolEndDateOptional
                            : MaterialLocalizations.of(
                                context,
                              ).formatFullDate(_endDate!),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_endDate != null)
                            IconButton(
                              tooltip: l10n.schoolClearEndDate,
                              onPressed: () => setState(() {
                                _endDate = null;
                                _dirty = true;
                              }),
                              icon: const Icon(Icons.clear),
                            ),
                          const Icon(Icons.calendar_today_outlined),
                        ],
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: _startDate ?? DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(labelText: l10n.childNotes),
                      minLines: 2,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.saveSchoolProfile),
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
      await ref.read(schoolProfilesRepositoryProvider).save(
            SchoolProfile(
              id: _loadedId ?? '',
              childId: child.id,
              schoolName: _name.text.trim(),
              startDate: _startDate,
              endDate: _endDate,
              className: _className.text.trim().isEmpty
                  ? null
                  : _className.text.trim(),
              teacherName: _teacher.text.trim().isEmpty
                  ? null
                  : _teacher.text.trim(),
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
          );
      ref.invalidate(schoolProfilesProvider);
      ref.invalidate(currentSchoolProvider);
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
