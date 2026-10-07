import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/domain/models/medicine.dart';
import 'package:shishur_dinlipi/features/health/health_labels.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MedicineListScreen extends ConsumerStatefulWidget {
  const MedicineListScreen({super.key});

  @override
  ConsumerState<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends ConsumerState<MedicineListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(medicinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicineTitle),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.medicineStatusActive),
            Tab(text: l10n.medicineStatusCompleted),
            Tab(text: l10n.medicineStatusAsNeeded),
            Tab(text: l10n.commonAll),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.medicineCreate),
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text(l10n.medicinesEmpty));
          }
          return TabBarView(
            controller: _tabs,
            children: [
              _MedicineList(
                items: items
                    .where((m) => m.status == MedicineStatuses.active)
                    .toList(),
                emptyLabel: l10n.medicinesEmpty,
              ),
              _MedicineList(
                items: items
                    .where((m) => m.status == MedicineStatuses.completed)
                    .toList(),
                emptyLabel: l10n.medicinesEmpty,
              ),
              _MedicineList(
                items: items
                    .where((m) => m.status == MedicineStatuses.asNeeded)
                    .toList(),
                emptyLabel: l10n.medicinesEmpty,
              ),
              _MedicineList(items: items, emptyLabel: l10n.medicinesEmpty),
            ],
          );
        },
      ),
    );
  }
}

class _MedicineList extends StatelessWidget {
  const _MedicineList({required this.items, required this.emptyLabel});

  final List<Medicine> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (items.isEmpty) {
      return Center(child: Text(emptyLabel));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(
              [
                medicineStatusLabel(l10n, item.status),
                if (item.dosage != null) item.dosage!,
                if (item.strength != null) item.strength!,
              ].join(' · '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.medicineDetailPath(item.id)),
          ),
        );
      },
    );
  }
}
