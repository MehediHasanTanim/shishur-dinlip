import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/birthdays/birthday_labels.dart';
import 'package:shishur_dinlipi/features/birthdays/birthdays_providers.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

class BirthdayDetailScreen extends ConsumerWidget {
  const BirthdayDetailScreen({super.key, required this.birthdayId});

  final String birthdayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(birthdayDetailProvider(birthdayId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.birthdayDetailTitle),
        actions: [
          IconButton(
            onPressed: () =>
                context.push(AppRoutes.birthdayEditPath(birthdayId)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: async.when(
        loading: () => AppStateViews.loading(),
        error: (e, _) => AppStateViews.error(message: '$e'),
        data: (birthday) {
          if (birthday == null) {
            return AppStateViews.empty(
              icon: Icons.cake_outlined,
              title: l10n.birthdayEmpty,
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${l10n.birthdayAge} ${birthday.age}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                MaterialLocalizations.of(context)
                    .formatFullDate(birthday.birthdayDate),
              ),
              if (birthday.theme != null) ...[
                const SizedBox(height: 12),
                _Row(label: l10n.birthdayTheme, value: birthday.theme!),
              ],
              if (birthday.locationText != null) ...[
                const SizedBox(height: 8),
                _Row(label: l10n.birthdayLocation, value: birthday.locationText!),
              ],
              if (birthday.favoriteGift != null) ...[
                const SizedBox(height: 8),
                _Row(
                  label: l10n.birthdayFavoriteGift,
                  value: birthday.favoriteGift!,
                ),
              ],
              if (birthday.guestsText != null) ...[
                const SizedBox(height: 8),
                _Row(label: l10n.birthdayGuests, value: birthday.guestsText!),
              ],
              if (birthday.parentMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.birthdayParentMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(birthday.parentMessage!),
              ],
              if (birthday.notes != null) ...[
                const SizedBox(height: 12),
                Text(birthday.notes!),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.birthdayInterview,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (birthday.answers.isEmpty)
                Text(
                  l10n.birthdayEmptyHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                )
              else
                ...birthday.answers.map(
                  (a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(birthdayQuestionLabel(l10n, a.questionKey)),
                    subtitle: Text(a.answer),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.push(
                  AppRoutes.birthdayInterviewPath(birthdayId),
                ),
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(l10n.birthdayInterviewTitle),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _createAlbum(context, ref, birthday.id),
                icon: const Icon(Icons.photo_album_outlined),
                label: Text(l10n.birthdayAlbumCreate),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _generatePdf(context, ref, birthday.id),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.birthdayPdfGenerate),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final ok = await AppStateViews.confirmDelete(
                    context,
                    title: l10n.commonDelete,
                    message: l10n.birthdayDetailTitle,
                  );
                  if (!ok) return;
                  await ref
                      .read(birthdaysRepositoryProvider)
                      .softDelete(birthday.id);
                  ref.invalidate(birthdaysListProvider);
                  if (context.mounted) context.pop();
                },
                child: Text(l10n.commonDelete),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createAlbum(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final birthday =
          await ref.read(birthdaysRepositoryProvider).getById(id);
      if (birthday == null) return;
      final child = ref.read(selectedChildProvider).valueOrNull;
      final album = await ref.read(birthdaysRepositoryProvider).ensureBirthdayAlbum(
            birthday,
            childName: child?.displayName,
          );
      ref.invalidate(birthdayDetailProvider(id));
      if (!context.mounted) return;
      AppStateViews.showSaveSuccess(context, l10n.birthdayAlbumReady);
      context.push(AppRoutes.albumDetailPath(album.id));
    } catch (e) {
      if (!context.mounted) return;
      AppStateViews.showSaveFailure(
        context,
        ErrorMapper.localize(context, e),
      );
    }
  }

  Future<void> _generatePdf(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final birthday =
          await ref.read(birthdaysRepositoryProvider).getById(id);
      if (birthday == null) return;
      final child = ref.read(selectedChildProvider).valueOrNull;
      final comparisons = await ref
          .read(birthdaysRepositoryProvider)
          .compareAnswersByAge(birthday.childId);
      if (!context.mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      final labels = birthdayQuestionLabelMap(l10n);
      final result = await ref.read(birthdayPdfGeneratorProvider).generate(
            birthday: birthday,
            childName: child?.displayName ?? 'Child',
            comparisons: comparisons,
            languageCode: locale,
            questionLabels: labels,
          );
      if (!context.mounted) return;
      AppStateViews.showSaveSuccess(context, l10n.birthdayPdfReady);
      await Share.shareXFiles(
        [XFile(result.absolutePath, mimeType: 'application/pdf')],
        text: result.title,
      );
    } catch (e) {
      if (!context.mounted) return;
      AppStateViews.showSaveFailure(
        context,
        ErrorMapper.localize(context, e),
      );
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
