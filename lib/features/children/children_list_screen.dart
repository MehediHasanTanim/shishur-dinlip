import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class ChildrenListScreen extends ConsumerWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final childrenAsync = ref.watch(childrenListProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;
    final selectedId = settings?.selectedChildId;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.childrenTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.childCreate),
        icon: const Icon(Icons.add),
        label: Text(l10n.addChild),
      ),
      body: childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (children) {
          if (children.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noChildrenTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noChildrenMessage,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final child = children[index];
              final age = AgeFormatter.format(
                age: AgeCalculator.current(child.dateOfBirth),
                bangla: bangla,
                useBengaliDigits: useBnDigits,
              );
              return Card(
                child: ListTile(
                  leading: ChildAvatar(child: child),
                  title: Text(child.name),
                  subtitle: Text(
                    [
                      if (child.nickname != null && child.nickname!.isNotEmpty)
                        child.nickname!,
                      age,
                      if (child.schoolName != null) child.schoolName!,
                    ].join(' · '),
                  ),
                  trailing: child.id == selectedId
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.childDetailPath(child.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
