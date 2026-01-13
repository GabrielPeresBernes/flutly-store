import 'dart:io';

import 'package:dio/dio.dart';

import '../core_http.dart';
import '../errors/http_exception.dart';

/// Dio implementation of the CoreHttp interface.
class DioProvider implements CoreHttp {
  DioProvider(this._dio);

  final Dio _dio;

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    required T Function(Map<String, dynamic>) decoder,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    if (!_isResponseSuccess(response)) {
      throw HttpException(
        'GET request failed',
        path: path,
        statusCode: response.statusCode,
      );
    }

    return decoder(
      response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{},
    );
  }

  @override
  Future<void> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: body,
      options: Options(headers: headers),
    );

    if (!_isResponseSuccess(response)) {
      throw HttpException(
        'POST request failed',
        path: path,
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.put<dynamic>(
      path,
      data: body,
      options: Options(headers: headers),
    );

    if (!_isResponseSuccess(response)) {
      throw HttpException(
        'PUT request failed',
        path: path,
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: body,
      options: Options(headers: headers),
    );

    if (!_isResponseSuccess(response)) {
      throw HttpException(
        'PATCH request failed',
        path: path,
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final response = await _dio.delete<dynamic>(
      path,
      options: Options(headers: headers),
    );

    if (!_isResponseSuccess(response)) {
      throw HttpException(
        'DELETE request failed',
        path: path,
        statusCode: response.statusCode,
      );
    }
  }

  bool _isResponseSuccess(Response<dynamic> response) =>
      response.statusCode != null &&
      response.statusCode! >= 200 &&
      response.statusCode! < 300;
}
