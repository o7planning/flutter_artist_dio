part of '../../flutter_artist_dio.dart';

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
Future<ApiResult<D>> _jsonDelete<D>(
  Dio dio,
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
  int restRequestId = 0;
  try {
    options = _createOptionsWithNotNullHeaders(options);
    restRequestId = _addRequestIdToHeaders(headers: options.headers!);
    //
    final response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
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
