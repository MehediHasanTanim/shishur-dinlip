import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

Future<void> showChildSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const ChildSwitcherSheet(),
  );
}

class ChildSwitcherSheet extends ConsumerWidget {
  const ChildSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final childrenAsync = ref.watch(childrenListProvider);
    final selectedAsync = ref.watch(selectedChildProvider);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;
    final selectedId = selectedAsync.valueOrNull?.id;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.selectChild, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            childrenAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('$error'),
              data: (children) {
                if (children.isEmpty) {
                  return Text(l10n.noChildrenMessage);
                }
                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: children.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final child = children[index];
                      final age = AgeFormatter.format(
                        age: AgeCalculator.current(child.dateOfBirth),
                        bangla: bangla,
                        useBengaliDigits: useBnDigits,
                      );
                      final selected = child.id == selectedId;
                      return ListTile(
                        leading: ChildAvatar(child: child, radius: 22),
                        title: Text(child.displayName),
                        subtitle: Text(age),
                        trailing: selected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () async {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .setSelectedChildId(child.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(AppRoutes.childCreate);
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addAnotherChild),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(AppRoutes.children);
              },
              child: Text(l10n.manageChildren),
            ),
          ],
        ),
      ),
    );
  }
}
