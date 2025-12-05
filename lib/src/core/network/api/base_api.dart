/// Base API class for Max Bot API
library;

import 'client.dart';
import 'error.dart';

/// Base API class providing HTTP methods
class BaseApi {
  final Client _client;

  const BaseApi(this._client);

  /// Make a GET request
  Future<Map<String, dynamic>> get(
    String method, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? path,
  }) async {
    return _callApi(
      method,
      RequestOptions(method: HttpMethod.get, query: query, path: path),
    );
  }

  /// Make a POST request
  Future<Map<String, dynamic>> post(
    String method, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? path,
  }) async {
    return _callApi(
      method,
      RequestOptions(method: HttpMethod.post, body: body, query: query, path: path),
    );
  }

  /// Make a PUT request
  Future<Map<String, dynamic>> put(
    String method, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? path,
  }) async {
    return _callApi(
      method,
      RequestOptions(method: HttpMethod.put, body: body, query: query, path: path),
    );
  }

  /// Make a PATCH request
  Future<Map<String, dynamic>> patch(
    String method, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? path,
  }) async {
    return _callApi(
      method,
      RequestOptions(method: HttpMethod.patch, body: body, query: query, path: path),
    );
  }

  /// Make a DELETE request
  Future<Map<String, dynamic>> delete(
    String method, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? path,
  }) async {
    return _callApi(
      method,
      RequestOptions(method: HttpMethod.delete, body: body, query: query, path: path),
    );
  }

  Future<Map<String, dynamic>> _callApi(
    String method,
    RequestOptions options,
  ) async {
    final result = await _client.call(method: method, options: options);
    if (result.status != 200) {
      throw MaxError.fromJson(result.status, result.data);
    }
    return result.data;
  }
}
