import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AddScreen extends ConsumerWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasChild =
        ref.watch(selectedChildProvider).valueOrNull != null;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            l10n.addTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            hasChild ? l10n.addSubtitle : l10n.noChildrenMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (!hasChild) ...[
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push(AppRoutes.childCreate),
              child: Text(l10n.addChild),
            ),
          ] else ...[
            const SizedBox(height: 24),
            Text(
              l10n.addGroupMemories,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _AddTile(
              icon: Icons.auto_stories_outlined,
              title: l10n.addMemory,
              subtitle: l10n.addMemorySubtitle,
              onTap: () => context.push(AppRoutes.journalCreate),
            ),
            _AddTile(
              icon: Icons.sentiment_very_satisfied_outlined,
              title: l10n.addFunnyMoment,
              subtitle: l10n.addFunnySubtitle,
              onTap: () => context.push(AppRoutes.funnyCreate),
            ),
            _AddTile(
              icon: Icons.emoji_events_outlined,
              title: l10n.addAchievement,
              subtitle: l10n.addAchievementSubtitle,
              onTap: () => context.push(AppRoutes.achievementCreate),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.quickTemplates,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final template in JournalTemplate.values)
                  ActionChip(
                    label: Text(_templateLabel(l10n, template)),
                    onPressed: () {
                      if (template.opensFunnyMoment) {
                        context.push(AppRoutes.funnyCreate);
                      } else {
                        context.push(
                          AppRoutes.journalCreatePath(template: template.name),
                        );
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.addGroupComingSoon,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addComingSoonMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _templateLabel(AppLocalizations l10n, JournalTemplate template) {
    return switch (template) {
      JournalTemplate.somethingFunny => l10n.templateSomethingFunny,
      JournalTemplate.somethingNew => l10n.templateSomethingNew,
      JournalTemplate.proudMoment => l10n.templateProudMoment,
      JournalTemplate.difficultDay => l10n.templateDifficultDay,
      JournalTemplate.favoriteMoment => l10n.templateFavoriteMoment,
      JournalTemplate.photoMemory => l10n.templatePhotoMemory,
    };
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
