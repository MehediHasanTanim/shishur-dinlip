import 'package:flutter/foundation.dart';

@immutable
class OAuthToken {
  const OAuthToken({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.tokenType = 'Bearer',
    this.scope,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final String tokenType;
  final String? scope;

  bool get isExpired {
    final exp = expiresAt;
    if (exp == null) return false;
    return DateTime.now().toUtc().isAfter(
      exp.subtract(const Duration(minutes: 1)),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt?.toIso8601String(),
    'tokenType': tokenType,
    'scope': scope,
  };

  factory OAuthToken.fromJson(Map<String, dynamic> json) {
    return OAuthToken(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '')?.toUtc(),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      scope: json['scope'] as String?,
    );
  }

  factory OAuthToken.fromTokenResponse(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'];
    DateTime? expiresAt;
    if (expiresIn is int) {
      expiresAt = DateTime.now().toUtc().add(Duration(seconds: expiresIn));
    } else if (expiresIn is String) {
      final secs = int.tryParse(expiresIn);
      if (secs != null) {
        expiresAt = DateTime.now().toUtc().add(Duration(seconds: secs));
      }
    }
    return OAuthToken(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String?,
      expiresAt: expiresAt,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      scope: json['scope'] as String?,
    );
  }
}
