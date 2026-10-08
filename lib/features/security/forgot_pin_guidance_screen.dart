import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shishur_dinlipi/app/router/app_routes.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/security/app_lock_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

/// UX §7.4 — local/offline recovery guidance (no online PIN reset).
class ForgotPinGuidanceScreen extends ConsumerStatefulWidget {
  const ForgotPinGuidanceScreen({super.key});

  @override
  ConsumerState<ForgotPinGuidanceScreen> createState() =>
      _ForgotPinGuidanceScreenState();
}

class _ForgotPinGuidanceScreenState
    extends ConsumerState<ForgotPinGuidanceScreen> {
  String? _error;
  var _busy = false;

  Future<void> _tryBiometric() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final settings = await ref.read(securitySettingsProvider.future);
      if (!settings.biometricsEnabled) {
        setState(() => _error = l10n.unlockBiometric);
        return;
      }
      final ok = await ref
          .read(appUnlockedProvider.notifier)
          .unlockWithBiometrics();
      if (ok && mounted) context.go(AppRoutes.home);
    } on SecurityFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(securitySettingsProvider);
    final biometricsOn = settingsAsync.valueOrNull?.biometricsEnabled == true;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotPinTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.lock_reset_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.forgotPinBody,
                style: theme.textTheme.bodyLarge,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const Spacer(),
              if (biometricsOn)
                FilledButton.icon(
                  onPressed: _busy ? null : _tryBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l10n.forgotPinBiometric),
                ),
              if (biometricsOn) const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => context.push(AppRoutes.restore),
                icon: const Icon(Icons.restore),
                label: Text(l10n.forgotPinRestore),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => context.go(AppRoutes.unlock),
                child: Text(l10n.forgotPinReturn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
