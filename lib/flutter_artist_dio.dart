import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/src/v1/token_storage.dart';

import 'src/v1/one_future_auth_interceptor.dart';

part 'src/v1/_error_handler/__handle_dio_exception.dart';
part 'src/v1/_error_handler/__handle_dio_response.dart';
part 'src/v1/_error_handler/__handle_exception.dart';
part 'src/v1/_model/request_log_info.dart';
//
part 'src/v1/api/_delete.dart';
part 'src/v1/api/_get.dart';
part 'src/v1/api/_post.dart';
part 'src/v1/api/_put.dart';
part 'src/v1/core/__base.dart';
part 'src/v1/core/_read_token_from_headers.dart';
part 'src/v1/core/_write_token_to_headers.dart';
part 'src/v1/fa_dio_interceptor.dart';
//
part 'src/v1/json/_json_delete.dart';
part 'src/v1/json/_json_get.dart';
part 'src/v1/json/_json_post.dart';
part 'src/v1/json/_json_put.dart';
//
part 'src/v1/logger/rest_logger.dart';

class FlutterArtistDio {
  late final Dio _dio;

  Dio get dio => _dio;

  FlutterArtistDio({
    BaseOptions? baseOptions,
    required TokenStorage tokenStorage,
    required WriteTokenToHeaders writeTokenToHeaders,
    required ReadTokenFromHeaders readTokenFromHeaders,
  }) {
    _dio = Dio(baseOptions);
    _dio.interceptors.add(
      OneFutureAuthInterceptor(
        dio: _dio,
        tokenStorage: tokenStorage,
        writeTokenToHeaders: writeTokenToHeaders,
      ),
    );
    _dio.interceptors.add(
      FaDioInterceptor(
        readTokenFromHeaders: readTokenFromHeaders,
      ),
    );
  }

  Future<ApiResult<D>> restGet<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    return _jsonGet<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      headers: headers,
      queryParameters: queryParameters,
      token: token,
      converter: converter,
      errorConverter: errorConverter,
      showDebug: showDebug,
    );
  }

  Future<ApiResult<D>> restPost<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
    Duration? receiveTimeout,
  }) async {
    return await _jsonPost<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
      converter: converter,
      errorConverter: errorConverter,
      showDebug: showDebug,
      receiveTimeout: receiveTimeout,
    );
  }

  Future<ApiResult<D>> restPut<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    return _jsonPut<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
      converter: converter,
      errorConverter: errorConverter,
      showDebug: showDebug,
    );
  }

  Future<ApiResult<D>> restDelete<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    return _jsonDelete<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
      converter: converter,
      errorConverter: errorConverter,
      showDebug: showDebug,
    );
  }
}
