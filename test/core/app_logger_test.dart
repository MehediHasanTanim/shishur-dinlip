import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/config/app_config.dart';
import 'package:shishur_dinlipi/core/config/app_flavor.dart';
import 'package:shishur_dinlipi/core/logging/app_logger.dart';

void main() {
  setUp(() {
    AppConfig.initialize(AppFlavor.dev);
  });

  test('logger accepts calls without throwing', () {
    expect(
      () => AppLogger.instance.debug('ok', {
        'journal': 'should redact',
        'count': 2,
      }),
      returnsNormally,
    );
  });
}
