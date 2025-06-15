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

  // Origin DIO Function:
  // Future<Response<T>> get<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onReceiveProgress,
  // });
  Future<ApiResult<D>> restGet<D>(
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
    // String? token (Deprecated).
  }) async {
    return _get<D>(
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

  // Origin DIO Function:
  // Future<Response<T>> post<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onSendProgress,
  //     ProgressCallback? onReceiveProgress,
  // });
  Future<ApiResult<D>> restPost<D>(
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
    return await _post<D>(
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

  // Origin DIO Function:
  // Future<Response<T>> put<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  //     ProgressCallback? onSendProgress,
  //     ProgressCallback? onReceiveProgress,
  // });
  Future<ApiResult<D>> restPut<D>(
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
    return _put<D>(
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

  // Origin DIO Function:
  // Future<Response<T>> delete<T>(
  //     String path, {
  //     Object? data,
  //     Map<String, dynamic>? queryParameters,
  //     Options? options,
  //     CancelToken? cancelToken,
  // });
  Future<ApiResult<D>> restDelete<D>(
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
    return _delete<D>(
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
}
