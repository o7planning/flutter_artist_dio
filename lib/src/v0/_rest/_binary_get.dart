part of '../flutter_artist_dio.dart';

// DIO:
//
// Future<Response<T>> get<T>(
//     String path, {
//       Object? data,
//       Map<String, dynamic>? queryParameters,
//       Options? options,
//       CancelToken? cancelToken,
//       ProgressCallback? onReceiveProgress,
// });
Future<ApiResult<D>> _binaryGetToDownload<D>(
  Dio dio,
  String path, {
  required ResponseDataMode responseDataMode,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? queryParameters,
  String? token,
  required Converter<D>? converter,
  ErrorConverter errorConverter = defaultErrorConverter,
  bool showDebug = false,
}) async {
  int restRequestId = 0;
  try {
    headers ??= {};
    restRequestId = _addRequestIdToHeaders(headers: headers);
    //
    if (token != null) {
      headers["Authorization"] = token;
    }
    // Content-Type: application/octet-stream
    // Content-Disposition: attachment; filename="picture.png"
    Options options = Options(
      headers: headers,
      contentType: 'application/octet-stream',
      followRedirects: false,
      validateStatus: (status) => true,
    );
    //
    final response = await dio.get(
      path,
      options: options,
      queryParameters: queryParameters,
    );

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
