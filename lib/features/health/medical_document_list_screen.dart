import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/medical_document.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicalDocumentListScreen extends ConsumerStatefulWidget {
  const MedicalDocumentListScreen({super.key});

  @override
  ConsumerState<MedicalDocumentListScreen> createState() =>
      _MedicalDocumentListScreenState();
}

class _MedicalDocumentListScreenState
    extends ConsumerState<MedicalDocumentListScreen> {
  String? _filterType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(medicalDocumentsProvider);
    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicalDocsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.medicalDocumentCreate),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(l10n.commonAll),
                    selected: _filterType == null,
                    onSelected: (_) => setState(() => _filterType = null),
                  ),
                ),
                for (final type in MedicalDocumentTypes.all)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(medicalDocumentTypeLabel(l10n, type)),
                      selected: _filterType == type,
                      onSelected: (_) => setState(() => _filterType = type),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.errorGeneric)),
              data: (items) {
                final filtered = _filterType == null
                    ? items
                    : items
                          .where((d) => d.documentType == _filterType)
                          .toList();
                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.medicalDocsEmpty));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.description_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          [
                            medicalDocumentTypeLabel(l10n, item.documentType),
                            if (item.documentDate != null)
                              dateFmt.formatMediumDate(item.documentDate!),
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          AppRoutes.medicalDocumentDetailPath(item.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
