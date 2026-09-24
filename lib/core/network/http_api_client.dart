import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_finder/core/errors/app_exception.dart';
import 'package:path_finder/core/logging/app_logger.dart';
import 'package:path_finder/core/network/api_client.dart';

class HttpApiClient implements ApiClient {
  HttpApiClient(
    this._client, {
    this._timeout = const Duration(seconds: 10),
    this._logger = const DefaultLogger(),
  });

  final http.Client _client;
  final Duration _timeout;
  final AppLogger _logger;

  static const _headers = {'Accept': 'application/json'};

  static const _maxLoggedBodyLength = 4000;
  static const _preparedJson = JsonEncoder.withIndent('  ');

  @override
  Future<Object?> getJson(Uri uri) async {
    _logger.info('GET $uri');
    final stopwatch = Stopwatch()..start();
    final http.Response response;
    try {
      response = await _client.get(uri, headers: _headers).timeout(_timeout);
    } on TimeoutException {
      _logger.warning('GET $uri: no response in ${_timeout.inSeconds} s');
      throw const RequestTimeoutException();
    } on http.ClientException catch (e) {
      _logger.warning('GET $uri failed', e);
      throw NetworkException(e.message);
    } on Exception catch (e) {
      _logger.warning('GET $uri failed', e);
      throw NetworkException(e.toString());
    }
    final elapsed = stopwatch.elapsed;

    final json = _tryDecode(response.bodyBytes);
    _logResponse('GET', uri, response, json, elapsed);
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

  void _logResponse(
    String method,
    Uri uri,
    http.Response response,
    Object? json,
    Duration elapsed,
  ) {
    _logger
      ..info(
        '$method $uri -> ${response.statusCode} (${elapsed.inMilliseconds} ms, ${response.bodyBytes.length} bytes)',
      )
      ..debug('Response body:\n${_bodyForLog(response.bodyBytes, json)}');
  }

  String _bodyForLog(List<int> bodyBytes, Object? json) {
    if (bodyBytes.isEmpty) return '<empty>';
    final text = json != null
        ? _preparedJson.convert(json)
        : utf8.decode(bodyBytes, allowMalformed: true);
    if (text.length <= _maxLoggedBodyLength) return text;
    final cut = text.length - _maxLoggedBodyLength;
    return '${text.substring(0, _maxLoggedBodyLength)}\n... $cut more characters';
  }
}
