import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/vaccination.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class VaccinationListScreen extends ConsumerStatefulWidget {
  const VaccinationListScreen({super.key});

  @override
  ConsumerState<VaccinationListScreen> createState() =>
      _VaccinationListScreenState();
}

class _VaccinationListScreenState extends ConsumerState<VaccinationListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(vaccinationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vaccinationTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.vaccineStatusUpcoming),
            Tab(text: l10n.vaccineStatusCompleted),
            Tab(text: l10n.commonAll),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.vaccinationCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.vaccinationsEmpty));
          }
          return TabBarView(
            controller: _tabs,
            children: [
              _VaccinationList(
                items: items
                    .where((v) => v.status == VaccinationStatuses.upcoming)
                    .toList(),
                emptyLabel: l10n.vaccinationsEmpty,
              ),
              _VaccinationList(
                items: items
                    .where((v) => v.status == VaccinationStatuses.completed)
                    .toList(),
                emptyLabel: l10n.vaccinationsEmpty,
              ),
              _VaccinationList(
                items: items,
                emptyLabel: l10n.vaccinationsEmpty,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VaccinationList extends StatelessWidget {
  const _VaccinationList({required this.items, required this.emptyLabel});

  final List<Vaccination> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFmt = MaterialLocalizations.of(context);

    if (items.isEmpty) {
      return Center(child: Text(emptyLabel));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        final date = item.givenDate ?? item.scheduledDate;
        return Card(
          child: ListTile(
            title: Text(item.vaccineName),
            subtitle: Text(
              [
                vaccinationStatusLabel(l10n, item.status),
                if (item.doseLabel != null) item.doseLabel!,
                if (date != null) dateFmt.formatMediumDate(date),
              ].join(' · '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                context.push(AppRoutes.vaccinationDetailPath(item.id)),
          ),
        );
      },
    );
  }
}
