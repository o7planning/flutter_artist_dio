part of '../../../flutter_artist_dio.dart';

// Future<Response<T>> delete<T>(
//     String path, {
//     Object? data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     CancelToken? cancelToken,
// });
Future<ApiResult<D>> _jsonDelete<D>(
  Dio dio,
  String path, {
  ResponseDataMode responseDataMode = ResponseDataMode.realData,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? queryParameters,
  dynamic data,
  required Converter<D>? converter,
  ErrorConverter errorConverter = defaultErrorConverter,
  bool showDebug = false,
}) async {
  int restRequestId = 0;
  try {
    headers ??= {};
    restRequestId = _addRequestIdToHeaders(headers: headers);
    //
    final response = await dio.delete(
      path,
      options: Options(headers: headers),
      queryParameters: queryParameters,
      data: data,
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
