import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/memories/widgets/discard_guard.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicalDocumentEditorScreen extends ConsumerStatefulWidget {
  const MedicalDocumentEditorScreen({super.key, this.documentId});

  final String? documentId;

  @override
  ConsumerState<MedicalDocumentEditorScreen> createState() =>
      _MedicalDocumentEditorScreenState();
}

class _MedicalDocumentEditorScreenState
    extends ConsumerState<MedicalDocumentEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;

  String _documentType = MedicalDocumentTypes.prescription;
  DateTime? _documentDate;
  String? _pendingFilePath;
  String? _pendingFileName;
  bool _pendingIsDocument = true;
  String _mediaAssetId = '';
  String? _existingFileName;
  bool _dirty = false;
  bool _saving = false;
  bool _loading = true;
  String? _loadedId;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController()..addListener(_markDirty);
    _notes = TextEditingController()..addListener(_markDirty);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  void _markDirty() {
    if (!_dirty && mounted) setState(() => _dirty = true);
  }

  Future<void> _bootstrap() async {
    if (widget.documentId != null) {
      final item = await ref
          .read(medicalDocumentsRepositoryProvider)
          .getById(widget.documentId!);
      if (item != null && mounted) {
        _loadedId = item.id;
        _createdAt = item.createdAt;
        _title.text = item.title;
        _notes.text = item.notes ?? '';
        _documentType = item.documentType;
        _documentDate = item.documentDate;
        _mediaAssetId = item.mediaAssetId;
        _existingFileName = item.media?.originalFilename;
      }
    }
    if (mounted) {
      setState(() {
        _loading = false;
        _dirty = false;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'webp', 'heic'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final path = file.path;
    if (path == null || path.isEmpty) return;
    final ext = p.extension(path).toLowerCase().replaceFirst('.', '');
    setState(() {
      _pendingFilePath = path;
      _pendingFileName = file.name;
      _pendingIsDocument = ext == 'pdf';
      _dirty = true;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);
    final fileLabel = _pendingFileName ?? _existingFileName;

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
            widget.documentId == null
                ? l10n.addMedicalDocument
                : l10n.editMedicalDocument,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  children: [
                    Text(l10n.medicalDocType),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in MedicalDocumentTypes.all)
                          ChoiceChip(
                            label: Text(medicalDocumentTypeLabel(l10n, type)),
                            selected: _documentType == type,
                            onSelected: (_) => setState(() {
                              _documentType = type;
                              _dirty = true;
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        labelText: l10n.medicalDocTitle,
                      ),
                      validator: (v) => (v ?? '').trim().isEmpty
                          ? l10n.medicalDocTitleRequired
                          : null,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.medicalDocDate),
                      subtitle: Text(
                        _documentDate == null
                            ? l10n.commonNone
                            : dateFmt.formatFullDate(_documentDate!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _documentDate ?? DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            _documentDate = picked;
                            _dirty = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: Text(l10n.medicalDocPickFile),
                    ),
                    if (fileLabel != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        fileLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notes,
                      decoration: InputDecoration(
                        labelText: l10n.medicalDocNotes,
                      ),
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
              child: Text(l10n.saveMedicalDocument),
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

    final needsFile = _mediaAssetId.isEmpty &&
        (_pendingFilePath == null || _pendingFilePath!.isEmpty);
    if (needsFile) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).medicalDocFileRequired),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now().toUtc();
      await ref.read(medicalDocumentsRepositoryProvider).save(
            document: MedicalDocument(
              id: _loadedId ?? '',
              childId: child.id,
              documentType: _documentType,
              title: _title.text.trim(),
              documentDate: _documentDate,
              mediaAssetId: _mediaAssetId,
              notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              createdAt: _createdAt ?? now,
              updatedAt: now,
            ),
            pendingFilePath: _pendingFilePath,
            isDocument: _pendingIsDocument,
          );
      ref.invalidate(medicalDocumentsProvider);
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
