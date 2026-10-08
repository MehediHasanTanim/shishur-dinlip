import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/health/health_providers.dart';
import 'package:shishur_dinlipi/features/health/widgets/health_disclaimer.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class HealthOverviewScreen extends ConsumerWidget {
  const HealthOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaryAsync = ref.watch(healthSummaryProvider);
    final dateFmt = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMenu(context, l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.healthAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Text(
            l10n.healthSummary,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          summaryAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Text(l10n.errorGeneric),
            data: (summary) {
              final growthParts = <String>[];
              final growth = summary.latestGrowth;
              if (growth != null) {
                if (growth.heightCm != null) {
                  growthParts.add('${growth.heightCm} cm');
                }
                if (growth.weightKg != null) {
                  growthParts.add('${growth.weightKg} kg');
                }
              }

              final isEmpty = (summary.bloodGroup == null ||
                      summary.bloodGroup!.isEmpty) &&
                  growthParts.isEmpty &&
                  summary.activeMedicines.isEmpty &&
                  summary.recentIllness == null &&
                  summary.recentVaccination == null &&
                  summary.latestDoctorVisit == null &&
                  summary.upcomingVaccines.isEmpty &&
                  summary.upcomingFollowUps.isEmpty;

              return Column(
                children: [
                  if (isEmpty) ...[
                    Text(
                      l10n.healthEmpty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _SummaryTile(
                    label: l10n.healthBloodGroup,
                    value: summary.bloodGroup?.isNotEmpty == true
                        ? summary.bloodGroup!
                        : l10n.commonNone,
                  ),
                  _SummaryTile(
                    label: l10n.healthLatestGrowth,
                    value: growthParts.isEmpty
                        ? l10n.commonNone
                        : growthParts.join(' · '),
                  ),
                  _SummaryTile(
                    label: l10n.healthCurrentMedicine,
                    value: summary.activeMedicines.isEmpty
                        ? l10n.commonNone
                        : summary.activeMedicines
                              .map((m) => m.name)
                              .take(3)
                              .join(', '),
                  ),
                  _SummaryTile(
                    label: l10n.healthRecentIllness,
                    value: summary.recentIllness?.title ?? l10n.commonNone,
                    onTap: summary.recentIllness == null
                        ? null
                        : () => context.push(
                            AppRoutes.illnessDetailPath(
                              summary.recentIllness!.id,
                            ),
                          ),
                  ),
                  _SummaryTile(
                    label: l10n.healthVaccination,
                    value: summary.recentVaccination?.vaccineName ??
                        l10n.commonNone,
                    onTap: summary.recentVaccination == null
                        ? null
                        : () => context.push(
                            AppRoutes.vaccinationDetailPath(
                              summary.recentVaccination!.id,
                            ),
                          ),
                  ),
                  _SummaryTile(
                    label: l10n.healthLastDoctorVisit,
                    value: summary.latestDoctorVisit == null
                        ? l10n.commonNone
                        : '${summary.latestDoctorVisit!.doctorName} · ${dateFmt.formatMediumDate(summary.latestDoctorVisit!.visitDate)}',
                    onTap: summary.latestDoctorVisit == null
                        ? null
                        : () => context.push(
                            AppRoutes.doctorVisitDetailPath(
                              summary.latestDoctorVisit!.id,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.healthUpcoming,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (summary.upcomingVaccines.isEmpty &&
                      summary.upcomingFollowUps.isEmpty)
                    Text(
                      l10n.commonNone,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  else ...[
                    for (final vax in summary.upcomingVaccines)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.vaccines_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(vax.vaccineName),
                        subtitle: vax.scheduledDate == null
                            ? null
                            : Text(
                                dateFmt.formatMediumDate(vax.scheduledDate!),
                              ),
                        onTap: () => context.push(
                          AppRoutes.vaccinationDetailPath(vax.id),
                        ),
                      ),
                    for (final visit in summary.upcomingFollowUps)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.event_available_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(visit.doctorName),
                        subtitle: visit.followUpDate == null
                            ? null
                            : Text(
                                dateFmt.formatMediumDate(visit.followUpDate!),
                              ),
                        onTap: () => context.push(
                          AppRoutes.doctorVisitDetailPath(visit.id),
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const HealthDisclaimer(),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              _GridCard(
                icon: Icons.vaccines_outlined,
                label: l10n.healthGridVaccinations,
                onTap: () => context.push(AppRoutes.vaccinations),
              ),
              _GridCard(
                icon: Icons.healing_outlined,
                label: l10n.healthGridIllness,
                onTap: () => context.push(AppRoutes.illnesses),
              ),
              _GridCard(
                icon: Icons.medication_outlined,
                label: l10n.healthGridMedicines,
                onTap: () => context.push(AppRoutes.medicines),
              ),
              _GridCard(
                icon: Icons.local_hospital_outlined,
                label: l10n.healthGridDoctorVisits,
                onTap: () => context.push(AppRoutes.doctorVisits),
              ),
              _GridCard(
                icon: Icons.folder_outlined,
                label: l10n.healthGridDocuments,
                onTap: () => context.push(AppRoutes.medicalDocuments),
              ),
              _GridCard(
                icon: Icons.document_scanner_outlined,
                label: l10n.ocrTitle,
                onTap: () => context.push(AppRoutes.ocrScan),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.vaccines_outlined),
              title: Text(l10n.addVaccination),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.vaccinationCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.healing_outlined),
              title: Text(l10n.addIllness),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.illnessCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medication_outlined),
              title: Text(l10n.addMedicine),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.medicineCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital_outlined),
              title: Text(l10n.addDoctorVisit),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.doctorVisitCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(l10n.addMedicalDocument),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.medicalDocumentCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: Text(l10n.ocrTitle),
              subtitle: Text(l10n.ocrAddSubtitle),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.ocrScan);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: scheme.primary, size: 28),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
