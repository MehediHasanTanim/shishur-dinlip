import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

enum AppPermission { camera, photos, notifications, biometrics, microphone }

enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  unavailable,
}

/// Requests OS permissions only at the point of use.
class PermissionService {
  PermissionService({LocalAuthentication? localAuth, AppLogger? logger})
    : _localAuth = localAuth ?? LocalAuthentication(),
      _logger = logger ?? AppLogger.instance;

  final LocalAuthentication _localAuth;
  final AppLogger _logger;

  Future<AppPermissionStatus> status(AppPermission permission) async {
    if (permission == AppPermission.biometrics) {
      return _biometricStatus();
    }
    final mapped = await _toHandler(permission).status;
    return _mapStatus(mapped);
  }

  Future<AppPermissionStatus> request(AppPermission permission) async {
    _logger.info('Requesting permission', {'permission': permission.name});
    if (permission == AppPermission.biometrics) {
      return _biometricStatus(promptIfNeeded: true);
    }
    final mapped = await _toHandler(permission).request();
    return _mapStatus(mapped);
  }

  /// Returns true when permission is usable; requests only if not already granted.
  Future<bool> ensure(AppPermission permission) async {
    final current = await status(permission);
    if (_isUsable(current)) return true;
    if (current == AppPermissionStatus.permanentlyDenied ||
        current == AppPermissionStatus.unavailable ||
        current == AppPermissionStatus.restricted) {
      return false;
    }
    final requested = await request(permission);
    return _isUsable(requested);
  }

  Future<bool> openSystemSettings() => ph.openAppSettings();

  ph.Permission _toHandler(AppPermission permission) {
    return switch (permission) {
      AppPermission.camera => ph.Permission.camera,
      AppPermission.photos =>
        Platform.isIOS ? ph.Permission.photos : ph.Permission.photos,
      AppPermission.notifications => ph.Permission.notification,
      AppPermission.microphone => ph.Permission.microphone,
      AppPermission.biometrics => ph.Permission.notification, // unused
    };
  }

  Future<AppPermissionStatus> _biometricStatus({
    bool promptIfNeeded = false,
  }) async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return AppPermissionStatus.unavailable;
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return AppPermissionStatus.unavailable;
      final available = await _localAuth.getAvailableBiometrics();
      if (available.isEmpty) return AppPermissionStatus.unavailable;
      if (promptIfNeeded) {
        // Availability check only — actual unlock happens in security sprint.
        return AppPermissionStatus.granted;
      }
      return AppPermissionStatus.granted;
    } catch (error) {
      _logger.warn('Biometric status failed', {
        'errorType': error.runtimeType.toString(),
      });
      return AppPermissionStatus.unavailable;
    }
  }

  AppPermissionStatus _mapStatus(ph.PermissionStatus status) {
    if (status.isGranted) {
      return AppPermissionStatus.granted;
    }
    if (status.isLimited) {
      return AppPermissionStatus.limited;
    }
    if (status.isPermanentlyDenied) {
      return AppPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) {
      return AppPermissionStatus.restricted;
    }
    if (status.isDenied) {
      return AppPermissionStatus.denied;
    }
    return AppPermissionStatus.unavailable;
  }

  bool _isUsable(AppPermissionStatus status) {
    return status == AppPermissionStatus.granted ||
        status == AppPermissionStatus.limited;
  }
}
