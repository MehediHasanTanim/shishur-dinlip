import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/security/app_lock_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class OnboardingSecurityScreen extends ConsumerStatefulWidget {
  const OnboardingSecurityScreen({super.key});

  @override
  ConsumerState<OnboardingSecurityScreen> createState() =>
      _OnboardingSecurityScreenState();
}

class _OnboardingSecurityScreenState
    extends ConsumerState<OnboardingSecurityScreen> {
  Future<void> _setPinFlow() async {
    final l10n = AppLocalizations.of(context);
    final pin = await _promptPin(l10n.securitySetPin);
    if (pin == null || !mounted) return;
    final confirm = await _promptPin(l10n.securityConfirmPin);
    if (confirm == null || !mounted) return;
    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.securityPinMismatch)),
      );
      return;
    }
    try {
      await ref.read(pinServiceProvider).setPin(pin);
      ref.invalidate(securitySettingsProvider);
      if (!mounted) return;
      context.go(AppRoutes.onboardingComplete);
    } on SecurityFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? l10n.errorGeneric)),
      );
    }
  }

  Future<void> _biometricsFlow() async {
    final l10n = AppLocalizations.of(context);
    // PIN is required before biometrics.
    final pin = await _promptPin(l10n.securitySetPin);
    if (pin == null || !mounted) return;
    final confirm = await _promptPin(l10n.securityConfirmPin);
    if (confirm == null || !mounted) return;
    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.securityPinMismatch)),
      );
      return;
    }
    try {
      final pins = ref.read(pinServiceProvider);
      await pins.setPin(pin);
      await ref.read(biometricServiceProvider).enable(
        pinService: pins,
        currentPin: pin,
      );
      ref.invalidate(securitySettingsProvider);
      if (!mounted) return;
      context.go(AppRoutes.onboardingComplete);
    } on SecurityFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? l10n.errorGeneric)),
      );
    }
  }

  Future<String?> _promptPin(String title) async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 8,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.unlockPinLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

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
                onPressed: _setPinFlow,
                child: Text(l10n.securitySetPin),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _biometricsFlow,
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
