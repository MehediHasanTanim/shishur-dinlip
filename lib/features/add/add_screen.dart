import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/features/development/milestone_templates.dart';
import 'package:shishur_dinlipi/features/memories/journal_templates.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class AddScreen extends ConsumerWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hasChild = ref.watch(selectedChildProvider).valueOrNull != null;

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
              l10n.addGroupMemoriesExtra,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _AddTile(
              icon: Icons.cake_outlined,
              title: l10n.addBirthday,
              subtitle: l10n.addBirthdaySubtitle,
              onTap: () => context.push(AppRoutes.birthdayCreate),
            ),
            _AddTile(
              icon: Icons.favorite_outline,
              title: l10n.addFavorite,
              subtitle: l10n.addFavoriteSubtitle,
              onTap: () => context.push(AppRoutes.favoriteCreate),
            ),
            _AddTile(
              icon: Icons.interests_outlined,
              title: l10n.addInterest,
              subtitle: l10n.addInterestSubtitle,
              onTap: () => context.push(AppRoutes.interestCreate),
            ),
            _AddTile(
              icon: Icons.celebration_outlined,
              title: l10n.addFamilyEvent,
              subtitle: l10n.addFamilyEventSubtitle,
              onTap: () => context.push(AppRoutes.familyEventCreate),
            ),
            _AddTile(
              icon: Icons.flight_takeoff_outlined,
              title: l10n.addTrip,
              subtitle: l10n.addTripSubtitle,
              onTap: () => context.push(AppRoutes.tripCreate),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  label: Text(l10n.familyEventTypeEid),
                  onPressed: () => context.push(
                    AppRoutes.familyEventCreatePath(type: 'eid'),
                  ),
                ),
                ActionChip(
                  label: Text(l10n.tripTypeFirstFlight),
                  onPressed: () => context.push(
                    AppRoutes.tripCreatePath(type: 'first_flight'),
                  ),
                ),
                ActionChip(
                  label: Text(l10n.tripTypeFirstBeach),
                  onPressed: () => context.push(
                    AppRoutes.tripCreatePath(type: 'first_beach'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.addGroupDevelopment,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _AddTile(
              icon: Icons.monitor_weight_outlined,
              title: l10n.addGrowth,
              subtitle: l10n.addGrowthSubtitle,
              onTap: () => context.push(AppRoutes.growthCreate),
            ),
            _AddTile(
              icon: Icons.stairs_outlined,
              title: l10n.addMilestone,
              subtitle: l10n.addMilestoneSubtitle,
              onTap: () => context.push(AppRoutes.milestoneCreate),
            ),
            _AddTile(
              icon: Icons.record_voice_over_outlined,
              title: l10n.addFirstWord,
              subtitle: l10n.addFirstWordSubtitle,
              onTap: () => context.push(AppRoutes.firstWordCreate),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.addGroupSchool,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _AddTile(
              icon: Icons.school_outlined,
              title: l10n.addSchoolProfile,
              subtitle: l10n.addSchoolProfileSubtitle,
              onTap: () => context.push(AppRoutes.schoolProfileCreate),
            ),
            _AddTile(
              icon: Icons.event_outlined,
              title: l10n.addSchoolEvent,
              subtitle: l10n.addSchoolEventSubtitle,
              onTap: () => context.push(AppRoutes.schoolEventCreate),
            ),
            _AddTile(
              icon: Icons.description_outlined,
              title: l10n.schoolEventReportCard,
              subtitle: l10n.addReportCardSubtitle,
              onTap: () => context.push(
                AppRoutes.schoolEventCreatePath(
                  eventType: 'report_card',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.healthTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _AddTile(
              icon: Icons.vaccines_outlined,
              title: l10n.addVaccination,
              subtitle: l10n.vaccineAttachmentsHint,
              onTap: () => context.push(AppRoutes.vaccinationCreate),
            ),
            _AddTile(
              icon: Icons.healing_outlined,
              title: l10n.addIllness,
              subtitle: l10n.illnessAttachmentsHint,
              onTap: () => context.push(AppRoutes.illnessCreate),
            ),
            _AddTile(
              icon: Icons.medication_outlined,
              title: l10n.addMedicine,
              subtitle: l10n.medicineSchedule,
              onTap: () => context.push(AppRoutes.medicineCreate),
            ),
            _AddTile(
              icon: Icons.local_hospital_outlined,
              title: l10n.addDoctorVisit,
              subtitle: l10n.doctorAttachmentsHint,
              onTap: () => context.push(AppRoutes.doctorVisitCreate),
            ),
            _AddTile(
              icon: Icons.folder_outlined,
              title: l10n.addMedicalDocument,
              subtitle: l10n.medicalDocPickFile,
              onTap: () => context.push(AppRoutes.medicalDocumentCreate),
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
                    label: Text(_journalTemplateLabel(l10n, template)),
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
                for (final template in MilestoneTemplate.values)
                  ActionChip(
                    label: Text(_milestoneTemplateLabel(l10n, template)),
                    onPressed: () {
                      if (template.opensFirstWord) {
                        context.push(AppRoutes.firstWordCreate);
                      } else {
                        context.push(
                          AppRoutes.milestoneCreatePath(
                            template: template.name,
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _journalTemplateLabel(
    AppLocalizations l10n,
    JournalTemplate template,
  ) {
    return switch (template) {
      JournalTemplate.somethingFunny => l10n.templateSomethingFunny,
      JournalTemplate.somethingNew => l10n.templateSomethingNew,
      JournalTemplate.proudMoment => l10n.templateProudMoment,
      JournalTemplate.difficultDay => l10n.templateDifficultDay,
      JournalTemplate.favoriteMoment => l10n.templateFavoriteMoment,
      JournalTemplate.photoMemory => l10n.templatePhotoMemory,
    };
  }

  String _milestoneTemplateLabel(
    AppLocalizations l10n,
    MilestoneTemplate template,
  ) {
    return switch (template) {
      MilestoneTemplate.firstCrawl => l10n.templateFirstCrawl,
      MilestoneTemplate.firstStand => l10n.templateFirstStand,
      MilestoneTemplate.firstStep => l10n.templateFirstStep,
      MilestoneTemplate.firstWalk => l10n.templateFirstWalk,
      MilestoneTemplate.firstRun => l10n.templateFirstRun,
      MilestoneTemplate.firstBicycle => l10n.templateFirstBicycle,
      MilestoneTemplate.firstWord => l10n.templateFirstWord,
      MilestoneTemplate.firstSentence => l10n.templateFirstSentence,
      MilestoneTemplate.wroteOwnName => l10n.templateWroteOwnName,
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
