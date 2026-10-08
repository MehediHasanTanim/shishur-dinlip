import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';
import 'package:shishur_dinlipi/core/security/app_lock_controller.dart';
import 'package:shishur_dinlipi/core/security/auto_lock_mode.dart';
import 'package:shishur_dinlipi/core/security/flag_secure.dart';
import 'package:shishur_dinlipi/core/settings/settings_controller.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  Future<String?> _askPin({
    required String title,
    required String label,
  }) async {
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
            labelText: label,
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

  Future<void> _setPin() async {
    final l10n = AppLocalizations.of(context);
    final pin = await _askPin(title: l10n.securitySetPin, label: l10n.unlockPinLabel);
    if (pin == null || pin.isEmpty) return;
    final confirm = await _askPin(
      title: l10n.securityConfirmPin,
      label: l10n.unlockPinLabel,
    );
    if (confirm == null) return;
    if (pin != confirm) {
      _toast(l10n.securityPinMismatch);
      return;
    }
    try {
      await ref.read(pinServiceProvider).setPin(pin);
      ref.invalidate(securitySettingsProvider);
      _toast(l10n.securityPinSet);
    } on SecurityFailure catch (e) {
      _toast(e.message ?? l10n.errorGeneric);
    }
  }

  Future<void> _changePin() async {
    final l10n = AppLocalizations.of(context);
    final current = await _askPin(
      title: l10n.securityChangePin,
      label: l10n.securityCurrentPin,
    );
    if (current == null) return;
    final next = await _askPin(
      title: l10n.securityNewPin,
      label: l10n.unlockPinLabel,
    );
    if (next == null) return;
    final confirm = await _askPin(
      title: l10n.securityConfirmPin,
      label: l10n.unlockPinLabel,
    );
    if (confirm == null) return;
    if (next != confirm) {
      _toast(l10n.securityPinMismatch);
      return;
    }
    try {
      await ref.read(pinServiceProvider).changePin(
        currentPin: current,
        newPin: next,
      );
      ref.invalidate(securitySettingsProvider);
      _toast(l10n.securityPinChanged);
    } on SecurityFailure catch (e) {
      _toast(e.message ?? l10n.errorGeneric);
    }
  }

  Future<void> _removePin() async {
    final l10n = AppLocalizations.of(context);
    final current = await _askPin(
      title: l10n.securityRemovePin,
      label: l10n.securityCurrentPin,
    );
    if (current == null) return;
    try {
      await ref.read(pinServiceProvider).removePin(current);
      ref.invalidate(securitySettingsProvider);
      _toast(l10n.securityPinRemoved);
    } on SecurityFailure catch (e) {
      _toast(e.message ?? l10n.errorGeneric);
    }
  }

  Future<void> _toggleBiometrics(bool enable) async {
    final l10n = AppLocalizations.of(context);
    final pin = await _askPin(
      title: enable ? l10n.securityBiometrics : l10n.securityDisableBiometrics,
      label: l10n.securityCurrentPin,
    );
    if (pin == null) return;
    try {
      final bio = ref.read(biometricServiceProvider);
      final pins = ref.read(pinServiceProvider);
      if (enable) {
        await bio.enable(pinService: pins, currentPin: pin);
      } else {
        await bio.disable(pinService: pins, currentPin: pin);
      }
      ref.invalidate(securitySettingsProvider);
    } on SecurityFailure catch (e) {
      _toast(e.message ?? l10n.errorGeneric);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(securitySettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securitySettingsTitle)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.errorGeneric)),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.securityAppLock,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (!settings.pinEnabled)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.pin_outlined),
                  title: Text(l10n.securitySetPin),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _setPin,
                )
              else ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.pin_outlined),
                  title: Text(l10n.securityChangePin),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _changePin,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_open_outlined),
                  title: Text(l10n.securityRemovePin),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _removePin,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.securityBiometrics),
                  subtitle: Text(l10n.securityBiometricsHint),
                  value: settings.biometricsEnabled,
                  onChanged: _toggleBiometrics,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.securityAutoLock,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AutoLockMode.values.map((mode) {
                    final selected = settings.autoLock == mode;
                    return ChoiceChip(
                      label: Text(_autoLockLabel(l10n, mode)),
                      selected: selected,
                      onSelected: (_) async {
                        await ref
                            .read(securitySettingsStoreProvider)
                            .setAutoLock(mode);
                        ref.invalidate(securitySettingsProvider);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(appUnlockedProvider.notifier).lock();
                  },
                  icon: const Icon(Icons.lock_outline),
                  label: Text(l10n.securityLockNow),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.securityPrivacySection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final appSettings =
                      ref.watch(settingsControllerProvider).valueOrNull;
                  final privacyOn =
                      appSettings?.notificationPrivacyMode ?? true;
                  final secureOn = appSettings?.flagSecure ?? false;
                  return Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.securityNotificationPrivacy),
                        subtitle: Text(l10n.securityNotificationPrivacyHint),
                        value: privacyOn,
                        onChanged: (value) async {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .setNotificationPrivacyMode(value);
                          await ref
                              .read(remindersRepositoryProvider)
                              .rescheduleAll();
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.securityFlagSecure),
                        subtitle: Text(l10n.securityFlagSecureHint),
                        value: secureOn,
                        onChanged: (value) async {
                          await ref
                              .read(settingsControllerProvider.notifier)
                              .setFlagSecure(value);
                          await FlagSecure.setEnabled(value);
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.securityEncryptionTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.securityEncryptionBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        },
      ),
    );
  }

  String _autoLockLabel(AppLocalizations l10n, AutoLockMode mode) {
    return switch (mode) {
      AutoLockMode.immediately => l10n.securityAutoLockImmediate,
      AutoLockMode.oneMinute => l10n.securityAutoLock1m,
      AutoLockMode.fiveMinutes => l10n.securityAutoLock5m,
      AutoLockMode.fifteenMinutes => l10n.securityAutoLock15m,
    };
  }
}
