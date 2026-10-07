import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.favorite_rounded, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _Chip(label: l10n.welcomeHighlightGrowth, icon: Icons.show_chart),
                  _Chip(label: l10n.welcomeHighlightHealth, icon: Icons.favorite_outline),
                  _Chip(label: l10n.welcomeHighlightMilestones, icon: Icons.star_outline),
                  _Chip(label: l10n.welcomeHighlightPhotos, icon: Icons.photo_outlined),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingCreateChild),
                child: Text(l10n.welcomeCta),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
