import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OnboardingPrivacyScreen extends StatelessWidget {
  const OnboardingPrivacyScreen({super.key});

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
              Icon(Icons.shield_outlined, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                l10n.privacyTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              _PrivacyPoint(icon: Icons.lock_outline, text: l10n.privacyPrivate),
              const SizedBox(height: 12),
              _PrivacyPoint(icon: Icons.wifi_off, text: l10n.privacyOffline),
              const SizedBox(height: 12),
              _PrivacyPoint(
                icon: Icons.manage_accounts_outlined,
                text: l10n.privacyControl,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingWelcome),
                child: Text(l10n.privacyContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ],
    );
  }
}
