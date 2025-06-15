part of '../../../fa_dio.dart';

// Future<Response<T>> post<T>(
//     String path, {
//       Object? data,
//       Map<String, dynamic>? queryParameters,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onSendProgress,
//       ProgressCallback? onReceiveProgress,
//     });

Future<ApiResult<D>> _jsonPost<D>(
  Dio dio,
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
  int restRequestId = 0;
  try {
    headers ??= {};
    restRequestId = _addRequestIdToHeaders(headers: headers);
    //
    final response = await dio.post(
      path,
      options: Options(
        headers: headers,
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
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
