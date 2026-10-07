import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/age.dart';
import 'package:shishur_dinlipi/core/domain/models/timeline_item.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_labels.dart';
import 'package:shishur_dinlipi/features/timeline/timeline_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class TimelineCard extends ConsumerWidget {
  const TimelineCard({super.key, required this.item, this.onTap});

  final TimelineItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final child = ref.watch(selectedChildProvider).valueOrNull;
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBnDigits = settings?.useBengaliDigits ?? false;
    final dateFmt = MaterialLocalizations.of(context);

    final ageLabel = child == null
        ? null
        : AgeFormatter.format(
            age: AgeCalculator.atEvent(
              dateOfBirth: child.dateOfBirth,
              eventDate: item.eventDate,
            ),
            bangla: bangla,
            useBengaliDigits: useBnDigits,
          );

    final subtitleParts = <String>[
      if (item.subtitle != null && item.subtitle!.trim().isNotEmpty)
        item.subtitle!.trim(),
      dateFmt.formatMediumDate(item.eventDate),
      if (ageLabel != null && ageLabel.isNotEmpty) ageLabel,
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          timelineTypeIcon(item.type),
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          [
            timelineTypeLabel(l10n, item.type),
            ...subtitleParts,
          ].join(' · '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: item.thumbnailRelativePath == null
            ? null
            : _TimelineThumb(relativePath: item.thumbnailRelativePath!),
        onTap: onTap ?? () => openTimelineItem(context, item),
      ),
    );
  }
}

class _TimelineThumb extends ConsumerWidget {
  const _TimelineThumb({required this.relativePath});

  final String relativePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<File>(
      future: ref
          .read(fileStorageServiceProvider)
          .absoluteFile(relativePath),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48,
            height: 48,
            child: file == null || !file.existsSync()
                ? ColoredBox(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Image.file(file, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

/// Horizontal filter chips bound to [timelineFilterProvider].
class TimelineFilterChips extends ConsumerWidget {
  const TimelineFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(timelineFilterProvider);

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final filter in TimelineFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(timelineFilterLabel(l10n, filter)),
                selected: selected == filter,
                onSelected: (_) {
                  ref.read(timelineFilterProvider.notifier).state = filter;
                },
              ),
            ),
        ],
      ),
    );
  }
}
