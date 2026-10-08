import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudHttpRequest {
  const CloudHttpRequest({
    required this.method,
    required this.uri,
    this.headers = const {},
    this.bodyBytes,
    this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final Uint8List? bodyBytes;
  final String? body;
}

class CloudHttpResponse {
  const CloudHttpResponse({
    required this.statusCode,
    required this.bodyBytes,
    this.headers = const {},
  });

  final int statusCode;
  final Uint8List bodyBytes;
  final Map<String, String> headers;

  String get body => utf8.decode(bodyBytes);

  dynamic get json {
    if (bodyBytes.isEmpty) return null;
    return jsonDecode(body);
  }

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// Thin HTTP seam so cloud providers can be tested without the network.
abstract class CloudHttpClient {
  Future<CloudHttpResponse> send(CloudHttpRequest request);
}

class DartCloudHttpClient implements CloudHttpClient {
  DartCloudHttpClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<CloudHttpResponse> send(CloudHttpRequest request) async {
    final req = http.Request(request.method, request.uri);
    req.headers.addAll(request.headers);
    if (request.bodyBytes != null) {
      req.bodyBytes = request.bodyBytes!;
    } else if (request.body != null) {
      req.body = request.body!;
    }
    final streamed = await _client.send(req);
    final bytes = await streamed.stream.toBytes();
    return CloudHttpResponse(
      statusCode: streamed.statusCode,
      bodyBytes: Uint8List.fromList(bytes),
      headers: streamed.headers.map(
        (k, v) => MapEntry(k.toLowerCase(), v),
      ),
    );
  }

  void close() => _client.close();
}

/// In-memory fake for unit tests.
class FakeCloudHttpClient implements CloudHttpClient {
  FakeCloudHttpClient(this.handler);

  final Future<CloudHttpResponse> Function(CloudHttpRequest request) handler;
  final List<CloudHttpRequest> requests = [];

  @override
  Future<CloudHttpResponse> send(CloudHttpRequest request) async {
    requests.add(request);
    return handler(request);
  }
}
