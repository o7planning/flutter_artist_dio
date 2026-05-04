part of '../flutter_artist_dio.dart';

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
