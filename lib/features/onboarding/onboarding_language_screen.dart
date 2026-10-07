import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/settings/app_settings.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OnboardingLanguageScreen extends ConsumerStatefulWidget {
  const OnboardingLanguageScreen({super.key});

  @override
  ConsumerState<OnboardingLanguageScreen> createState() =>
      _OnboardingLanguageScreenState();
}

class _OnboardingLanguageScreenState
    extends ConsumerState<OnboardingLanguageScreen> {
  AppLanguage? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected =
        _selected ??
        ref.watch(settingsControllerProvider).valueOrNull?.language ??
        AppLanguage.english;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.chooseLanguageTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 32),
              _LanguageCard(
                title: l10n.settingsLanguageEnglish,
                selected: selected == AppLanguage.english,
                onTap: () => setState(() => _selected = AppLanguage.english),
              ),
              const SizedBox(height: 12),
              _LanguageCard(
                title: l10n.settingsLanguageBangla,
                selected: selected == AppLanguage.bangla,
                onTap: () => setState(() => _selected = AppLanguage.bangla),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setLanguage(selected);
                  if (context.mounted) {
                    context.go(AppRoutes.onboardingPrivacy);
                  }
                },
                child: Text(l10n.commonContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: theme.textTheme.titleLarge),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
