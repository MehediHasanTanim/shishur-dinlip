import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/approximate_date.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class FirstWordsListScreen extends ConsumerWidget {
  const FirstWordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    final useBn =
        ref.watch(settingsControllerProvider).valueOrNull?.useBengaliDigits ??
        false;
    final child = ref.watch(selectedChildProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.firstWordsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.firstWordCreate),
        child: const Icon(Icons.add),
      ),
      body: child == null
          ? Center(child: Text(l10n.noChildrenMessage))
          : FutureBuilder(
              future: ref
                  .read(firstWordsRepositoryProvider)
                  .forChild(child.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final words = snapshot.data!;
                if (words.isEmpty) {
                  return Center(child: Text(l10n.firstWordsEmpty));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '"${word.word}"',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        subtitle: Text(
                          [
                            if (word.languageCode != null) word.languageCode!,
                            ApproximateDateFormatter.format(
                              date: word.eventDate,
                              precision: word.datePrecision,
                              bangla: bangla,
                              useBengaliDigits: useBn,
                            ),
                          ].join(' · '),
                        ),
                        trailing: word.audioAssetId != null
                            ? const Icon(Icons.graphic_eq)
                            : null,
                        onTap: () => context.push(
                          AppRoutes.firstWordDetailPath(word.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
