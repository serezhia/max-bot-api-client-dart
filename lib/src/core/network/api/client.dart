/// HTTP client for Max Bot API
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Default base URL for Max API
const _defaultBaseUrl = 'https://platform-api.max.ru';

/// HTTP methods
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  final String value;
  const HttpMethod(this.value);
}

/// Options for configuring the API client
class ClientOptions {
  final String baseUrl;

  const ClientOptions({
    this.baseUrl = _defaultBaseUrl,
  });
}

/// Request options
class RequestOptions {
  final HttpMethod method;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? query;
  final Map<String, dynamic>? path;

  const RequestOptions({
    this.method = HttpMethod.get,
    this.body,
    this.query,
    this.path,
  });
}

/// API response
class ApiResponse {
  final int status;
  final Map<String, dynamic> data;

  const ApiResponse({required this.status, required this.data});
}

/// API client for making HTTP requests to Max API
class Client {
  final String _token;
  final String _baseUrl;
  final http.Client _httpClient;

  Client(this._token, {ClientOptions options = const ClientOptions()})
      : _baseUrl = options.baseUrl,
        _httpClient = http.Client();

  /// Build URL with path parameters
  String _buildUrl(String endpoint, Map<String, dynamic>? pathParams) {
    var url = endpoint;
    pathParams?.forEach((key, value) {
      url = url.replaceAll('{$key}', value.toString());
    });
    return url;
  }

  /// Make an API call
  Future<ApiResponse> call({
    required String method,
    required RequestOptions options,
  }) async {
    if (_token.isEmpty) {
      return const ApiResponse(
        status: 401,
        data: {
          'code': 'verify.token',
          'message': 'Empty access_token',
        },
      );
    }

    final endpoint = _buildUrl(method, options.path);
    final uri = Uri.parse('$_baseUrl/$endpoint');

    // Add query parameters
    final queryParams = <String, String>{};
    options.query?.forEach((key, value) {
      if (value != null) {
        queryParams[key] = value.toString();
      }
    });

    final finalUri = queryParams.isEmpty
        ? uri
        : uri.replace(queryParameters: queryParams);

    final headers = <String, String>{
      'Authorization': _token,
      if (options.body != null) 'Content-Type': 'application/json',
    };

    http.Response response;

    try {
      switch (options.method) {
        case HttpMethod.get:
          response = await _httpClient.get(finalUri, headers: headers);
        case HttpMethod.post:
          response = await _httpClient.post(
            finalUri,
            headers: headers,
            body: options.body != null ? jsonEncode(options.body) : null,
          );
        case HttpMethod.put:
          response = await _httpClient.put(
            finalUri,
            headers: headers,
            body: options.body != null ? jsonEncode(options.body) : null,
          );
        case HttpMethod.patch:
          response = await _httpClient.patch(
            finalUri,
            headers: headers,
            body: options.body != null ? jsonEncode(options.body) : null,
          );
        case HttpMethod.delete:
          response = await _httpClient.delete(
            finalUri,
            headers: headers,
            body: options.body != null ? jsonEncode(options.body) : null,
          );
      }
    } on Exception {
      rethrow;
    }

    if (response.statusCode == 401) {
      return const ApiResponse(
        status: 401,
        data: {
          'code': 'verify.token',
          'message': 'Invalid access_token',
        },
      );
    }

    final data = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    return ApiResponse(status: response.statusCode, data: data);
  }

  /// Close the HTTP client
  void close() {
    _httpClient.close();
  }
}

/// Create a new API client
Client createClient(String token, [ClientOptions? options]) {
  return Client(token, options: options ?? const ClientOptions());
}
