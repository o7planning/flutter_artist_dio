import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/src/_utils/dio_error_utils.dart';
import 'package:flutter_artist_dio/src/_utils/json_utils.dart';

import 'src/one_future_auth_interceptor.dart';

part 'src/_core/__core.dart';
part 'src/_error_detector/__json_conversion_error_detector.dart';
part 'src/_error_detector/__wrap_map.dart';
part 'src/_error_handler/__handle_dio_exception.dart';
part 'src/_error_handler/__handle_dio_response.dart';
part 'src/_error_handler/__handle_exception.dart';
part 'src/_logger/rest_logger.dart';
part 'src/_model/error_type.dart';
part 'src/_model/request_log_info.dart';
part 'src/_rest_binary/_download.dart';
//
part 'src/_rest_binary/_get_binary.dart';
part 'src/_rest_json/_delete.dart';
part 'src/_rest_json/_get.dart';
part 'src/_rest_json/_options.dart';
part 'src/_rest_json/_post.dart';
part 'src/_rest_json/_put.dart';
part 'src/fa_dio_interceptor.dart';

class FlutterArtistDio {
  late final Dio _dio;

  Dio get dio => _dio;

  // docs: 14751.
  FlutterArtistDio({
    required BaseOptions? baseOptions,
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

  //
  // Origin DIO Function:
  //
  // Future<Response<T>> get<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onReceiveProgress,
  // });
  //
  Future<ApiResult<D>> jsonGet<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonGet<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  //
  // Origin DIO Function:
  //
  // Future<Response<T>> post<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onSendProgress,
  //     ProgressCallback? onReceiveProgress,
  // });
  //
  Future<ApiResult<D>> jsonPost<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _jsonPost<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  //
  // Origin DIO Function:
  //
  // Future<Response<T>> put<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onSendProgress,
  //     ProgressCallback? onReceiveProgress,
  // });
  //
  Future<ApiResult<D>> jsonPut<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _jsonPut<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  //
  // Origin DIO Function:
  //
  // Future<Response<T>> delete<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  // });
  //
  Future<ApiResult<D>> jsonDelete<D>(
    String path, {
    ResponseDataMode responseDataMode = ResponseDataMode.realData,
    required Converter<D>? converter,
    bool showDebug = false,
    //
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _jsonDelete<D>(
      dio,
      path,
      responseDataMode: responseDataMode,
      converter: converter,
      showDebug: showDebug,
      //
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResult<List<int>?>> binaryGet(
    String path, {
    bool showDebug = false,
    //
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Object? data,
    Options? options,
  }) async {
    return await _binaryGet(
      dio,
      path,
      showDebug: showDebug,
      //
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      data: data,
      options: options,
    );
  }
}
