import 'package:flutter_test/flutter_test.dart';
import 'package:shishur_dinlipi/core/errors/error_mapper.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

void main() {
  test('maps known failures without wrapping', () {
    const failure = DatabaseFailure(message: 'db');
    expect(ErrorMapper.map(failure), same(failure));
  });

  test('maps unknown errors to UnknownFailure', () {
    final mapped = ErrorMapper.map(StateError('boom'));
    expect(mapped, isA<UnknownFailure>());
  });
}
