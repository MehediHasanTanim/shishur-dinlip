import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/id_generator.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/children/widgets/child_form.dart';
import 'package:shishur_dinlipi/features/children/widgets/photo_source_sheet.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// Holds the child id created during onboarding so later steps can attach a photo.
final onboardingChildIdProvider = StateProvider<String?>((ref) => null);

class OnboardingCreateChildScreen extends ConsumerWidget {
  const OnboardingCreateChildScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final form = ChildFormData(id: idGenerator.next());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createFirstChildTitle)),
      body: ChildForm(
        initial: form,
        showExtendedFields: false,
        submitLabel: l10n.commonContinue,
        onSubmit: (data) async {
          final child = data.toChild();
          final saved = await ref
              .read(childrenListProvider.notifier)
              .save(child);
          await ref
              .read(settingsControllerProvider.notifier)
              .setSelectedChildId(saved.id);
          ref.read(onboardingChildIdProvider.notifier).state = saved.id;

          if (!context.mounted) return;
          final action = await showPhotoSourceSheet(context);
          if (action == PhotoSheetAction.camera ||
              action == PhotoSheetAction.gallery) {
            try {
              await ref.read(profilePhotoServiceProvider).pickAndAttach(
                    child: saved,
                    source: action == PhotoSheetAction.camera
                        ? ImageSource.camera
                        : ImageSource.gallery,
                  );
              await ref.read(childrenListProvider.notifier).refresh();
            } on AppFailure catch (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.message ?? l10n.errorPermission)),
                );
              }
            }
          }

          if (context.mounted) {
            context.go(AppRoutes.onboardingSecurity);
          }
        },
      ),
    );
  }
}
