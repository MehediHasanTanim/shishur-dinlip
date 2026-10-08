import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class PkcePair {
  const PkcePair({required this.verifier, required this.challenge});

  final String verifier;
  final String challenge;

  /// RFC 7636 S256 PKCE pair.
  factory PkcePair.generate({Random? random}) {
    final rng = random ?? Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => rng.nextInt(256)),
    );
    final verifier = _base64UrlNoPad(bytes);
    final challenge = _base64UrlNoPad(
      Uint8List.fromList(sha256.convert(utf8.encode(verifier)).bytes),
    );
    return PkcePair(verifier: verifier, challenge: challenge);
  }

  static String _base64UrlNoPad(List<int> bytes) {
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}
