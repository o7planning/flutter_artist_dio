part of '../../flutter_artist_dio.dart';

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
Future<ApiResult<D>> _get<D>(
  Dio dio,
  String path, {
  required ResponseDataMode responseDataMode,
  required Converter<D>? converter,
  bool showDebug = false,
  //
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
}) async {
  int restRequestId = 0;
  try {
    options = _createOptionsWithNotNullHeaders(options);
    restRequestId = _addRequestIdToHeaders(headers: options.headers!);
    //
    final response = await dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    //
    return _handleDioResponse<D>(
      responseDataMode: responseDataMode,
      response: response,
      converter: converter,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  } on DioException catch (e, stackTrace) {
    return _handleDioException(
      e,
      stackTrace: stackTrace,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  } catch (e, stackTrace) {
    return _handleException(
      e,
      stackTrace: stackTrace,
      restRequestId: restRequestId,
      showDebug: showDebug,
    );
  }
}
