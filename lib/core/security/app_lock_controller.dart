import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shishur_dinlipi/core/di/core_providers.dart';
import 'package:shishur_dinlipi/core/security/auto_lock_mode.dart';
import 'package:shishur_dinlipi/core/security/security_settings_store.dart';

final securitySettingsProvider = FutureProvider<SecuritySettings>((ref) async {
  return ref.watch(securitySettingsStoreProvider).load();
});

/// Blur overlay for app-switcher / background privacy.
final backgroundObscuredProvider = StateProvider<bool>((ref) => false);

/// Session unlock gate. Starts unlocked; [bootstrap] locks when PIN is enabled.
final appUnlockedProvider =
    NotifierProvider<AppLockController, bool>(AppLockController.new);

class AppLockController extends Notifier<bool> {
  DateTime? _pausedAt;

  @override
  bool build() => true;

  Future<void> bootstrap() async {
    final settings = await ref.read(securitySettingsStoreProvider).load();
    state = !settings.appLockEnabled;
  }

  void unlock() => state = true;

  void lock() => state = false;

  Future<bool> unlockWithPin(String pin) async {
    final pinService = ref.read(pinServiceProvider);
    await pinService.verifyPin(pin); // throws SecurityFailure on failure
    state = true;
    _pausedAt = null;
    return true;
  }

  Future<bool> unlockWithBiometrics() async {
    final settings = await ref.read(securitySettingsStoreProvider).load();
    if (!settings.biometricsEnabled) return false;
    final bio = ref.read(biometricServiceProvider);
    final ok = await bio.authenticate(reason: 'Unlock Shishur Dinlipi');
    if (ok) {
      state = true;
      _pausedAt = null;
    }
    return ok;
  }

  void onAppPaused() {
    _pausedAt = DateTime.now();
    ref.read(backgroundObscuredProvider.notifier).state = true;
  }

  void onAppInactive() {
    ref.read(backgroundObscuredProvider.notifier).state = true;
  }

  Future<void> onAppResumed() async {
    ref.read(backgroundObscuredProvider.notifier).state = false;
    final settings = await ref.read(securitySettingsStoreProvider).load();
    if (!settings.appLockEnabled) {
      state = true;
      return;
    }
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt == null) return;
    final elapsed = DateTime.now().difference(pausedAt);
    final timeout = settings.autoLock.timeout ?? Duration.zero;
    if (settings.autoLock == AutoLockMode.immediately || elapsed >= timeout) {
      state = false;
    }
  }
}

/// Lifecycle binder that drives auto-lock + snapshot privacy blur.
class AppPrivacyLifecycle extends ConsumerStatefulWidget {
  const AppPrivacyLifecycle({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppPrivacyLifecycle> createState() =>
      _AppPrivacyLifecycleState();
}

class _AppPrivacyLifecycleState extends ConsumerState<AppPrivacyLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final lock = ref.read(appUnlockedProvider.notifier);
    switch (state) {
      case AppLifecycleState.inactive:
        lock.onAppInactive();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        lock.onAppPaused();
      case AppLifecycleState.resumed:
        lock.onAppResumed();
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final obscure = ref.watch(backgroundObscuredProvider);
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (obscure)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: const Color(0xE6FFFBF0),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Color(0xFF006D5B),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
