import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.moreTitle, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.child_care_outlined),
              title: Text(l10n.childrenTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.children),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.show_chart),
              title: Text(l10n.growthTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.growth),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.stairs_outlined),
              title: Text(l10n.milestonesTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.milestones),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settingsTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.settings),
            ),
          ),
        ],
      ),
    );
  }
}
