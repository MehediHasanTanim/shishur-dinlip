import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/features/children/child_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';
import 'package:shishur_dinlipi/shared/widgets/child_avatar.dart';

class OnboardingCompleteScreen extends ConsumerWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final child = ref.watch(selectedChildProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.setupCompleteTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.setupCompleteSubtitle(child?.displayName ?? '…'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (child != null) ...[
                const SizedBox(height: 24),
                Center(child: ChildAvatar(child: child, radius: 40)),
                const SizedBox(height: 8),
                Text(
                  child.displayName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .completeOnboarding();
                  if (context.mounted) context.go(AppRoutes.home);
                },
                child: Text(l10n.goToHome),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .completeOnboarding();
                  if (context.mounted) context.go(AppRoutes.add);
                },
                child: Text(l10n.addFirstMemory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
