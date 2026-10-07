import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/children/widgets/child_form.dart';
import 'package:shishur_dinlipi/features/children/widgets/photo_source_sheet.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class ChildEditorScreen extends ConsumerStatefulWidget {
  const ChildEditorScreen({super.key, this.childId});

  final String? childId;

  bool get isEditing => childId != null;

  @override
  ConsumerState<ChildEditorScreen> createState() => _ChildEditorScreenState();
}

class _ChildEditorScreenState extends ConsumerState<ChildEditorScreen> {
  ChildFormData? _form;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.childId == null) {
      setState(() => _form = ChildFormData(id: idGenerator.next()));
      return;
    }
    final child = await ref.read(childrenRepositoryProvider).getById(
          widget.childId!,
        );
    if (!mounted) return;
    setState(() {
      _form = child == null
          ? ChildFormData(id: idGenerator.next())
          : ChildFormData.fromChild(child);
    });
  }

  Future<void> _handlePhoto() async {
    final form = _form;
    if (form == null) return;
    final l10n = AppLocalizations.of(context);
    final action = await showPhotoSourceSheet(
      context,
      showRemove: form.profilePhotoId != null,
    );
    if (action == null || !mounted) return;

    try {
      // Ensure child exists before attaching photo.
      var child = form.toChild();
      child = await ref.read(childrenListProvider.notifier).save(child);
      _form = ChildFormData.fromChild(child);

      final photos = ref.read(profilePhotoServiceProvider);
      if (action == PhotoSheetAction.remove) {
        final updated = await photos.removePhoto(child);
        setState(() => _form = ChildFormData.fromChild(updated));
        await ref.read(childrenListProvider.notifier).refresh();
        return;
      }

      final source = action == PhotoSheetAction.camera
          ? ImageSource.camera
          : ImageSource.gallery;
      await photos.pickAndAttach(child: child, source: source);
      await ref.read(childrenListProvider.notifier).refresh();
      final refreshed = await ref
          .read(childrenRepositoryProvider)
          .getById(child.id);
      if (refreshed != null && mounted) {
        setState(() => _form = ChildFormData.fromChild(refreshed));
      }
    } on AppFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? l10n.errorPermission)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final form = _form;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editChild : l10n.addChild),
      ),
      body: form == null
          ? const Center(child: CircularProgressIndicator())
          : ChildForm(
              key: ValueKey('${form.id}-${form.profilePhotoId}'),
              initial: form,
              onPhotoTap: _handlePhoto,
              onSubmit: (data) async {
                final saved = await ref
                    .read(childrenListProvider.notifier)
                    .save(data.toChild());
                final settings =
                    ref.read(settingsControllerProvider).valueOrNull;
                if (settings?.selectedChildId == null) {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setSelectedChildId(saved.id);
                }
                if (context.mounted) context.pop();
              },
            ),
    );
  }
}
