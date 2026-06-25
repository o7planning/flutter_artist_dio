part of '../../../flutter_artist_dio.dart';

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
Future<ApiResult<D>> _jsonPut<D>(
  Dio dio,
  String path, {
  required FaJsonConverter<D> jsonConverter,
  required ErrorInfoExtractor errorInfoExtractor,
  bool showDebug = false,
  //
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
}) async {
  try {
    final response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    //
    return _handleDioResponse<D>(
      response: response,
      jsonConverter: jsonConverter,
    );
  } on DioException catch (e, stackTrace) {
    return _handleDioException(
      e,
      stackTrace: stackTrace,
      errorInfoExtractor: errorInfoExtractor,
    );
  } catch (e, stackTrace) {
    return _handleException(
      e,
      stackTrace: stackTrace,
    );
  }
}
