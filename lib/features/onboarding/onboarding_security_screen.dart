import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OnboardingSecurityScreen extends StatelessWidget {
  const OnboardingSecurityScreen({super.key});

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
              Icon(Icons.fingerprint, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                l10n.securityTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.securitySubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.securityLater)),
                  );
                  context.go(AppRoutes.onboardingComplete);
                },
                child: Text(l10n.securitySetPin),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.securityLater)),
                  );
                  context.go(AppRoutes.onboardingComplete);
                },
                child: Text(l10n.securityBiometrics),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingComplete),
                child: Text(l10n.securityLater),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
