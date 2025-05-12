import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_rest_core/flutter_artist_rest_core.dart';

part 'src/_error_handler/__handle_dio_exception.dart';
part 'src/_error_handler/__handle_dio_response.dart';
part 'src/_error_handler/__handle_exception.dart';
part 'src/_interceptor/app_dio_interceptor.dart';
part 'src/_model/request_log_info.dart';
part 'src/_rest/__base.dart';
part 'src/_rest/_binary_get.dart';
part 'src/_rest/_json_delete.dart';
part 'src/_rest/_json_get.dart';
part 'src/_rest/_json_post.dart';
part 'src/_rest/_json_put.dart';
part 'src/logger/rest_logger.dart';

// -----------------------------------------------------------------------------
//
//
//
// -----------------------------------------------------------------------------

class FlutterArtistDio {
  final String _appBaseURL;
  final String? Function()? _getCurrentToken;
  late final Dio dio;

  FlutterArtistDio({
    required String appBaseURL,
    required String? Function()? getCurrentToken,
    required void Function(Map<String, dynamic> headers, String accessToken)?
        addAuthorizationToHeaders,
  })  : _appBaseURL = appBaseURL,
        _getCurrentToken = getCurrentToken {
    dio = Dio(
      BaseOptions(
        baseUrl: appBaseURL,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      FlutterArtistDioInterceptor(
        appBaseURL: appBaseURL,
        getCurrentUserToken: getCurrentToken,
        addAuthorizationToHeaders: addAuthorizationToHeaders,
      ),
    );
  }

  String get appBaseURL {
    return _appBaseURL;
  }

  String? getCurrentUserToken() {
    return _getCurrentToken!();
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

  Future<ApiResult<D>> getBinaryDownload<D>(
    String path, {
    required ResponseDataMode responseDataMode,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? token,
    required Converter<D>? converter,
    ErrorConverter errorConverter = defaultErrorConverter,
    bool showDebug = false,
  }) async {
    return _binaryGetToDownload<D>(
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
}
