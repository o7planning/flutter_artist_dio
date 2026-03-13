import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/src/core/_model/detailed_data.dart';
import 'package:flutter_artist_dio/src/core/_utils/api_log_utils.dart';
import 'package:flutter_artist_dio/src/core/_utils/dio_error_utils.dart';

part 'src/core/_error_detector/__json_conversion_error_detector.dart';
part 'src/core/_error_detector/__wrap_map.dart';
part 'src/core/_error_handler/__handle_dio_exception.dart';
part 'src/core/_error_handler/__handle_dio_response.dart';
part 'src/core/_error_handler/__handle_exception.dart';
part 'src/core/_model/api_log_data.dart';
part 'src/core/_model/api_logger.dart';
part 'src/core/_model/error_log_data.dart';
part 'src/core/_model/request_log_data.dart';
part 'src/core/_model/response_log_data.dart';
part 'src/core/_rest_binary/_download.dart';
//
part 'src/core/_rest_binary/_get_binary.dart';
part 'src/core/_rest_json/_delete.dart';
part 'src/core/_rest_json/_get.dart';
part 'src/core/_rest_json/_options.dart';
part 'src/core/_rest_json/_post.dart';
part 'src/core/_rest_json/_put.dart';
part 'src/flutter_artist_dio_logger_interceptor.dart';

class FlutterArtistDio {
  final ErrorInfoExtractor errorInfoExtractor;
  final Dio dio;

  // docs: 14751.
  FlutterArtistDio({
    required this.dio,
    this.errorInfoExtractor = const FlexibleErrorInfoExtractor(),
  });

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
      errorInfoExtractor: errorInfoExtractor,
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
      errorInfoExtractor: errorInfoExtractor,
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
      errorInfoExtractor: errorInfoExtractor,
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
      errorInfoExtractor: errorInfoExtractor,
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
      errorInfoExtractor: errorInfoExtractor,
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
