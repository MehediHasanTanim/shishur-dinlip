import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/security/app_lock_controller.dart';
import 'package:shishur_dinlipi/core/security/security_settings_store.dart';
import 'package:shishur_dinlipi/features/security/unlock_screen.dart';
import 'package:shishur_dinlipi/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('unlock screen shows Forgot PIN link', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          securitySettingsProvider.overrideWith(
            (ref) async => const SecuritySettings(
              pinEnabled: true,
              biometricsEnabled: false,
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: UnlockScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Forgot PIN?'), findsOneWidget);
  });

  testWidgets('localizations expose privacy and OCR gap-fix copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: SizedBox.shrink(),
      ),
    );

    final context = tester.element(find.byType(SizedBox));
    final l10n = AppLocalizations.of(context);
    expect(l10n.unlockForgotPin, 'Forgot PIN?');
    expect(l10n.securityNotificationPrivacy, contains('Private'));
    expect(l10n.securityFlagSecure, contains('screenshot'));
    expect(l10n.ocrBanglaLimitation, contains('বাংলা'));
    expect(l10n.attachVideo, contains('video'));
  });
}
