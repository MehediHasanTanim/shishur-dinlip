import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/storage/storage_management_service.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/app_state_views.dart';

final storageSummaryProvider =
    FutureProvider.autoDispose<StorageUsageSummary>((ref) {
      return ref.watch(storageManagementServiceProvider).summarize();
    });

class StorageScreen extends ConsumerWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaryAsync = ref.watch(storageSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storageTitle)),
      body: summaryAsync.when(
        loading: () => AppStateViews.loading(message: l10n.stateLoading),
        error: (_, _) => AppStateViews.error(
          onRetry: () => ref.invalidate(storageSummaryProvider),
        ),
        data: (summary) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.storageTotal(_formatBytes(summary.totalBytes)),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (summary.isAlmostFull) ...[
                const SizedBox(height: 8),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_outlined),
                    title: Text(l10n.storageAlmostFull),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ...summary.categories.map((c) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_categoryLabel(l10n, c.key)),
                  subtitle: Text(l10n.storageFileCount(c.fileCount)),
                  trailing: Text(_formatBytes(c.bytes)),
                );
              }),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.storageOrphans),
                subtitle: Text(l10n.storageOrphanCount(summary.orphanCount)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.storageExports),
                subtitle: Text(l10n.storageExportCount(summary.exportCount)),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await ref
                      .read(storageManagementServiceProvider)
                      .cleanupTemp();
                  ref.invalidate(storageSummaryProvider);
                  if (context.mounted) {
                    AppStateViews.showSaveSuccess(
                      context,
                      l10n.storageTempCleaned,
                    );
                  }
                },
                icon: const Icon(Icons.cleaning_services_outlined),
                label: Text(l10n.storageCleanupTemp),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final removed = await ref
                      .read(storageManagementServiceProvider)
                      .cleanupGeneratedExports();
                  ref.invalidate(storageSummaryProvider);
                  if (context.mounted) {
                    AppStateViews.showSaveSuccess(
                      context,
                      l10n.storageExportsCleaned(removed),
                    );
                  }
                },
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: Text(l10n.storageCleanupExports),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: summary.orphanCount == 0
                    ? null
                    : () async {
                        final removed = await ref
                            .read(storageManagementServiceProvider)
                            .cleanupOrphanMedia();
                        ref.invalidate(storageSummaryProvider);
                        if (context.mounted) {
                          AppStateViews.showSaveSuccess(
                            context,
                            l10n.storageOrphansCleaned(removed),
                          );
                        }
                      },
                icon: const Icon(Icons.link_off_outlined),
                label: Text(l10n.storageCleanupOrphans),
              ),
            ],
          );
        },
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      'database' => l10n.storageCatDatabase,
      'media/images' => l10n.storageCatImages,
      'media/thumbnails' => l10n.storageCatThumbnails,
      'media/documents' => l10n.storageCatDocuments,
      'exports/pdf' => l10n.storageCatPdf,
      'exports/album_images' => l10n.storageCatAlbumImages,
      'backups' => l10n.storageCatBackups,
      'temp' => l10n.storageCatTemp,
      _ => key,
    };
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
