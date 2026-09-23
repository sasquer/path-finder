import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/network/api_client.dart';

class HttpApiClient implements ApiClient {
  HttpApiClient(this._client, {this._timeout = const Duration(seconds: 5)});

  final http.Client _client;
  final Duration _timeout;
  static const _headers = {'Accept': 'application/json'};

  @override
  Future<Object?> getJson(Uri uri) async {
    final http.Response response;
    try {
      response = await _client.get(uri, headers: _headers).timeout(_timeout);
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw NetworkException(e.toString());
    }

    final json = _tryDecode(response.bodyBytes);
    if (!_isSuccessful(response.statusCode)) {
      throw ServerException(response.statusCode, _messageFrom(json));
    }
    if (json == null) {
      throw const InvalidResponseException('Response body is not valid JSON');
    }
    return json;
  }

  bool _isSuccessful(int statusCode) => statusCode >= 200 && statusCode < 300;

  Object? _tryDecode(Uint8List bodyBytes) {
    if (bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(bodyBytes));
    } on FormatException {
      return null;
    }
  }

  String? _messageFrom(Object? json) => switch (json) {
    {'message': final String message} when message.isNotEmpty => message,
    _ => null,
  };
}
