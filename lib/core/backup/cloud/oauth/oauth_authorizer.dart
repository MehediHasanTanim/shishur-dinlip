import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

/// Opens the system browser / ASWebAuthenticationSession for OAuth.
abstract class OAuthAuthorizer {
  Future<Uri> authorize({
    required Uri authorizationUrl,
    required String callbackUrlScheme,
  });
}

class FlutterWebAuthAuthorizer implements OAuthAuthorizer {
  const FlutterWebAuthAuthorizer();

  @override
  Future<Uri> authorize({
    required Uri authorizationUrl,
    required String callbackUrlScheme,
  }) async {
    final result = await FlutterWebAuth2.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );
    return Uri.parse(result);
  }
}

/// Test double that returns a fixed callback URL.
class FakeOAuthAuthorizer implements OAuthAuthorizer {
  FakeOAuthAuthorizer(this.callbackUrl);

  final Uri callbackUrl;
  Uri? lastAuthorizationUrl;

  @override
  Future<Uri> authorize({
    required Uri authorizationUrl,
    required String callbackUrlScheme,
  }) async {
    lastAuthorizationUrl = authorizationUrl;
    return callbackUrl;
  }
}
