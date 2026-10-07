import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shishur_dinlipi/core/domain/models/child.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class ChildFormData {
  ChildFormData({
    this.id = '',
    this.name = '',
    this.nickname,
    DateTime? dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.birthWeightKg,
    this.birthHeightCm,
    this.birthplace,
    this.schoolName,
    this.className,
    this.profilePhotoId,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : dateOfBirth = dateOfBirth ?? DateTime(2020, 1, 1),
       createdAt = createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
       updatedAt = updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory ChildFormData.fromChild(Child child) {
    return ChildFormData(
      id: child.id,
      name: child.name,
      nickname: child.nickname,
      dateOfBirth: child.dateOfBirth,
      gender: child.gender,
      bloodGroup: child.bloodGroup,
      birthWeightKg: child.birthWeightKg,
      birthHeightCm: child.birthHeightCm,
      birthplace: child.birthplace,
      schoolName: child.schoolName,
      className: child.className,
      profilePhotoId: child.profilePhotoId,
      notes: child.notes,
      createdAt: child.createdAt,
      updatedAt: child.updatedAt,
    );
  }

  String id;
  String name;
  String? nickname;
  DateTime dateOfBirth;
  String? gender;
  String? bloodGroup;
  double? birthWeightKg;
  double? birthHeightCm;
  String? birthplace;
  String? schoolName;
  String? className;
  String? profilePhotoId;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Child toChild() {
    return Child(
      id: id,
      name: name.trim(),
      nickname: _emptyToNull(nickname),
      dateOfBirth: DateTime(
        dateOfBirth.year,
        dateOfBirth.month,
        dateOfBirth.day,
      ),
      gender: gender,
      bloodGroup: _emptyToNull(bloodGroup),
      birthWeightKg: birthWeightKg,
      birthHeightCm: birthHeightCm,
      birthplace: _emptyToNull(birthplace),
      schoolName: _emptyToNull(schoolName),
      className: _emptyToNull(className),
      profilePhotoId: profilePhotoId,
      notes: _emptyToNull(notes),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}

class ChildForm extends StatefulWidget {
  const ChildForm({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.onPhotoTap,
    this.showExtendedFields = true,
    this.submitLabel,
  });

  final ChildFormData initial;
  final Future<void> Function(ChildFormData data) onSubmit;
  final VoidCallback? onPhotoTap;
  final bool showExtendedFields;
  final String? submitLabel;

  @override
  State<ChildForm> createState() => _ChildFormState();
}

class _ChildFormState extends State<ChildForm> {
  late final TextEditingController _name;
  late final TextEditingController _nickname;
  late final TextEditingController _blood;
  late final TextEditingController _birthplace;
  late final TextEditingController _school;
  late final TextEditingController _className;
  late final TextEditingController _notes;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late ChildFormData _data;
  String? _nameError;
  String? _dobError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _data = widget.initial;
    _name = TextEditingController(text: _data.name);
    _nickname = TextEditingController(text: _data.nickname ?? '');
    _blood = TextEditingController(text: _data.bloodGroup ?? '');
    _birthplace = TextEditingController(text: _data.birthplace ?? '');
    _school = TextEditingController(text: _data.schoolName ?? '');
    _className = TextEditingController(text: _data.className ?? '');
    _notes = TextEditingController(text: _data.notes ?? '');
    _weight = TextEditingController(
      text: _data.birthWeightKg?.toString() ?? '',
    );
    _height = TextEditingController(
      text: _data.birthHeightCm?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _nickname.dispose();
    _blood.dispose();
    _birthplace.dispose();
    _school.dispose();
    _className.dispose();
    _notes.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    _nameError = null;
    _dobError = null;
    if (_name.text.trim().isEmpty) {
      _nameError = l10n.childNameRequired;
    }
    final today = DateTime.now();
    final dob = DateTime(
      _data.dateOfBirth.year,
      _data.dateOfBirth.month,
      _data.dateOfBirth.day,
    );
    if (dob.isAfter(DateTime(today.year, today.month, today.day))) {
      _dobError = l10n.childDobFuture;
    }
    setState(() {});
    return _nameError == null && _dobError == null;
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_validate(l10n)) return;
    setState(() => _saving = true);
    try {
      _data
        ..name = _name.text
        ..nickname = _nickname.text
        ..bloodGroup = _blood.text
        ..birthplace = _birthplace.text
        ..schoolName = _school.text
        ..className = _className.text
        ..notes = _notes.text
        ..birthWeightKg = double.tryParse(_weight.text)
        ..birthHeightCm = double.tryParse(_height.text);
      await widget.onSubmit(_data);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final preview = _data.toChild().copyWith(
      name: _name.text.trim().isEmpty ? ' ' : _name.text.trim(),
      nickname: _nickname.text,
    );

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Center(
                child: GestureDetector(
                  onTap: widget.onPhotoTap,
                  child: Column(
                    children: [
                      ChildAvatar(child: preview, radius: 48),
                      if (widget.onPhotoTap != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.addPhotoTitle,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.basicSection, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: l10n.childName,
                  errorText: _nameError,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nickname,
                decoration: InputDecoration(labelText: l10n.childNickname),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.childDob),
                subtitle: Text(
                  MaterialLocalizations.of(context).formatFullDate(
                    _data.dateOfBirth,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _data.dateOfBirth,
                    firstDate: DateTime(1980),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _data.dateOfBirth = picked);
                  }
                },
              ),
              if (_dobError != null)
                Text(
                  _dobError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 8),
              Text(l10n.childGender),
              const SizedBox(height: 8),
              SegmentedButton<String?>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ChildGender.boy,
                    label: Text(l10n.childGenderBoy),
                  ),
                  ButtonSegment(
                    value: ChildGender.girl,
                    label: Text(l10n.childGenderGirl),
                  ),
                  ButtonSegment(
                    value: ChildGender.other,
                    label: Text(l10n.childGenderOther),
                  ),
                ],
                selected: {_data.gender},
                onSelectionChanged: (value) {
                  setState(() => _data.gender = value.isEmpty ? null : value.first);
                },
              ),
              if (widget.showExtendedFields) ...[
                const SizedBox(height: 24),
                Text(l10n.healthSection, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: _blood,
                  decoration: InputDecoration(labelText: l10n.childBloodGroup),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weight,
                  decoration: InputDecoration(labelText: l10n.childBirthWeight),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _height,
                  decoration: InputDecoration(labelText: l10n.childBirthHeight),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                ),
                const SizedBox(height: 24),
                Text(l10n.birthSection, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: _birthplace,
                  decoration: InputDecoration(labelText: l10n.childBirthplace),
                ),
                const SizedBox(height: 24),
                Text(l10n.schoolSection, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: _school,
                  decoration: InputDecoration(labelText: l10n.childSchool),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _className,
                  decoration: InputDecoration(labelText: l10n.childClass),
                ),
                const SizedBox(height: 24),
                Text(l10n.notesSection, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: _notes,
                  decoration: InputDecoration(labelText: l10n.childNotes),
                  minLines: 3,
                  maxLines: 5,
                ),
              ],
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: _saving ? null : () => _submit(l10n),
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.submitLabel ?? l10n.saveChild),
            ),
          ),
        ),
      ],
    );
  }
}
