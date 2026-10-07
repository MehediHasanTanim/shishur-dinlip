import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/domain/models/school_profile.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/features/school/school_providers.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SchoolProfileDetailScreen extends ConsumerStatefulWidget {
  const SchoolProfileDetailScreen({super.key, required this.profileId});

  final String profileId;

  @override
  ConsumerState<SchoolProfileDetailScreen> createState() =>
      _SchoolProfileDetailScreenState();
}

class _SchoolProfileDetailScreenState
    extends ConsumerState<SchoolProfileDetailScreen> {
  SchoolProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final profile = await ref
        .read(schoolProfilesRepositoryProvider)
        .getById(widget.profileId);
    if (mounted) {
      setState(() {
        _profile = profile;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final profile = _profile;
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.schoolName),
        actions: [
          IconButton(
            onPressed: () async {
              await context.push(AppRoutes.schoolProfileEditPath(profile.id));
              await _load();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => _delete(profile),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          AppRoutes.schoolEventCreatePath(schoolProfileId: profile.id),
        ),
        icon: const Icon(Icons.event),
        label: Text(l10n.addSchoolEvent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (profile.isCurrent)
            Chip(label: Text(l10n.schoolCurrentBadge)),
          if (profile.className != null) ...[
            const SizedBox(height: 12),
            Text(
              '${l10n.schoolClass}: ${profile.className}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          if (profile.teacherName != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.schoolTeacher}: ${profile.teacherName}'),
          ],
          if (profile.startDate != null) ...[
            const SizedBox(height: 12),
            Text(
              '${l10n.schoolStartDate}: ${MaterialLocalizations.of(context).formatFullDate(profile.startDate!)}',
            ),
          ],
          if (profile.endDate != null) ...[
            const SizedBox(height: 4),
            Text(
              '${l10n.schoolEndDate}: ${MaterialLocalizations.of(context).formatFullDate(profile.endDate!)}',
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(l10n.schoolEndDateOptional),
          ],
          if (profile.notes != null) ...[
            const SizedBox(height: 16),
            Text(profile.notes!),
          ],
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => context.push(AppRoutes.schoolTimeline),
            child: Text(l10n.schoolTimeline),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(SchoolProfile profile) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSchoolTitle),
        content: Text(l10n.deleteSchoolMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(schoolProfilesRepositoryProvider).softDelete(profile.id);
      ref.invalidate(schoolProfilesProvider);
      ref.invalidate(currentSchoolProvider);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.localize(context, error))),
      );
    }
  }
}
