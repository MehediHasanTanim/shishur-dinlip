import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class ChildDetailScreen extends ConsumerWidget {
  const ChildDetailScreen({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final childAsync = ref.watch(childByIdProvider(childId));
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;

    return childAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('$error')),
      ),
      data: (child) {
        if (child == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.noChildrenTitle)),
          );
        }

        final age = AgeFormatter.format(
          age: AgeCalculator.current(child.dateOfBirth),
          bangla: bangla,
          useBengaliDigits: useBnDigits,
        );
        final dob = DateFormat.yMMMMd(
          Localizations.localeOf(context).toString(),
        ).format(child.dateOfBirth);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.childProfile),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.push(AppRoutes.childEditPath(child.id)),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: ChildAvatar(child: child, radius: 56)),
              const SizedBox(height: 16),
              Text(
                child.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (child.nickname != null && child.nickname!.isNotEmpty)
                Text(
                  child.nickname!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 8),
              Text(
                age,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                dob,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.aboutSection, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (child.bloodGroup != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.childBloodGroup),
                  subtitle: Text(child.bloodGroup!),
                ),
              if (child.schoolName != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.childSchool),
                  subtitle: Text(
                    [
                      child.schoolName,
                      if (child.className != null) child.className,
                    ].join(' · '),
                  ),
                ),
              if (child.notes != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.childNotes),
                  subtitle: Text(child.notes!),
                ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .setSelectedChildId(child.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.setAsSelected)),
                  );
                },
                child: Text(l10n.setAsSelected),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _confirmDelete(context, ref, child.name),
                child: Text(l10n.deleteChildConfirm),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteChildTitle),
        content: Text(l10n.deleteChildMessage(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteChildConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(childrenListProvider.notifier).softDelete(childId);
    if (context.mounted) context.pop();
  }
}
