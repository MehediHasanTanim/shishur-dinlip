import 'dart:convert';

import 'package:shishur_dinlipi/core/backup/cloud/backup_provider.dart';
import 'package:shishur_dinlipi/core/backup/cloud/cloud_http_client.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_authorizer.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/oauth_token_store.dart';
import 'package:shishur_dinlipi/core/backup/cloud/oauth/pkce.dart';
import 'package:shishur_dinlipi/core/errors/failures.dart';

/// Shared PKCE authorization-code + refresh flow for cloud providers.
class OAuthSession {
  OAuthSession({
    required this.providerId,
    required this.clientId,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.redirectUri,
    required this.scopes,
    required this.authorizer,
    required this.http,
    required this.tokenStore,
    this.extraAuthParams = const {},
    this.extraTokenParams = const {},
  });

  final BackupProviderId providerId;
  final String clientId;
  final Uri authorizationEndpoint;
  final Uri tokenEndpoint;
  final String redirectUri;
  final List<String> scopes;
  final OAuthAuthorizer authorizer;
  final CloudHttpClient http;
  final OAuthTokenStore tokenStore;
  final Map<String, String> extraAuthParams;
  final Map<String, String> extraTokenParams;

  Future<bool> get isSignedIn async {
    final token = await tokenStore.read(providerId);
    return token != null && token.accessToken.isNotEmpty;
  }

  Future<void> connect() async {
    if (clientId.trim().isEmpty) {
      throw const BackupFailure(
        message: 'Cloud backup is not configured for this build.',
      );
    }
    final pkce = PkcePair.generate();
    final authParams = <String, String>{
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'code_challenge': pkce.challenge,
      'code_challenge_method': 'S256',
      'state': pkce.verifier.substring(0, 16),
      ...extraAuthParams,
    };
    if (scopes.isNotEmpty) {
      authParams['scope'] = scopes.join(' ');
    }
    final authUrl = authorizationEndpoint.replace(queryParameters: authParams);

    final callback = await authorizer.authorize(
      authorizationUrl: authUrl,
      callbackUrlScheme: Uri.parse(redirectUri).scheme,
    );
    final error = callback.queryParameters['error'];
    if (error != null) {
      throw BackupFailure(
        message: callback.queryParameters['error_description'] ??
            'Sign-in was cancelled or denied ($error).',
      );
    }
    final code = callback.queryParameters['code'];
    if (code == null || code.isEmpty) {
      throw const BackupFailure(message: 'OAuth callback missing code.');
    }

    final token = await _exchangeToken({
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': redirectUri,
      'client_id': clientId,
      'code_verifier': pkce.verifier,
      ...extraTokenParams,
    });
    await tokenStore.write(providerId, token);
  }

  Future<void> disconnect() => tokenStore.clear(providerId);

  Future<String> accessToken() async {
    var token = await tokenStore.read(providerId);
    if (token == null || token.accessToken.isEmpty) {
      throw const BackupFailure(message: 'Not signed in to cloud backup.');
    }
    if (token.isExpired &&
        token.refreshToken != null &&
        token.refreshToken!.isNotEmpty) {
      token = await _exchangeToken({
        'grant_type': 'refresh_token',
        'refresh_token': token.refreshToken!,
        'client_id': clientId,
        ...extraTokenParams,
      });
      await tokenStore.write(providerId, token);
    }
    return token.accessToken;
  }

  Future<OAuthToken> _exchangeToken(Map<String, String> fields) async {
    final response = await http.send(
      CloudHttpRequest(
        method: 'POST',
        uri: tokenEndpoint,
        headers: const {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: fields.entries
            .map(
              (e) =>
                  '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
            )
            .join('&'),
      ),
    );
    if (!response.isSuccess) {
      throw BackupFailure(
        message: 'Could not complete cloud sign-in (${response.statusCode}).',
        cause: response.body,
      );
    }
    final json = response.json;
    if (json is! Map) {
      throw const BackupFailure(message: 'Invalid OAuth token response.');
    }
    final token = OAuthToken.fromTokenResponse(Map<String, dynamic>.from(json));
    if (token.accessToken.isEmpty) {
      throw const BackupFailure(message: 'OAuth token response missing access_token.');
    }
    // Preserve refresh token when refresh response omits it.
    if (token.refreshToken == null) {
      final previous = await tokenStore.read(providerId);
      if (previous?.refreshToken != null) {
        return OAuthToken(
          accessToken: token.accessToken,
          refreshToken: previous!.refreshToken,
          expiresAt: token.expiresAt,
          tokenType: token.tokenType,
          scope: token.scope,
        );
      }
    }
    return token;
  }

  Map<String, dynamic> decodeJsonObject(CloudHttpResponse response) {
    final json = response.json;
    if (json is! Map) {
      throw BackupFailure(
        message: 'Unexpected cloud response (${response.statusCode}).',
        cause: response.body,
      );
    }
    return Map<String, dynamic>.from(json);
  }

  Never throwHttp(CloudHttpResponse response, String action) {
    throw BackupFailure(
      message: 'Cloud $action failed (${response.statusCode}).',
      cause: response.body,
    );
  }

  String jsonEncodeBody(Object value) => jsonEncode(value);
}
