part of '../../flutter_artist_dio.dart';

//
// Origin DIO Function:
//
// Future<Response> download(
//   String urlPath,
//   dynamic savePath, {
//     ProgressCallback? onReceiveProgress,
//     Map<String, dynamic>? queryParameters,
//     CancelToken? cancelToken,
//     bool deleteOnError = true,
//     FileAccessMode fileAccessMode = FileAccessMode.write,
//     String lengthHeader = Headers.contentLengthHeader,
//     Object? data,
//     Options? options,
// });
//
Future<ApiResult<void>> _webDownload(
  Dio dio,
  String path,
  dynamic savePath, {
  bool showDebug = false,
  //
  ProgressCallback? onReceiveProgress,
  Map<String, dynamic>? queryParameters,
  CancelToken? cancelToken,
  bool deleteOnError = true,
  FileAccessMode fileAccessMode = FileAccessMode.write,
  String lengthHeader = Headers.contentLengthHeader,
  Object? data,
  Options? options,
}) async {
  int restRequestId = 0;
  try {
    options = _createOptionsWithNotNullHeaders(options);
    restRequestId = _addRequestIdToHeaders(headers: options.headers!);
    //
    final response = await dio.download(
      path,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      fileAccessMode: fileAccessMode,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
    //
    return _handleDioResponse(
      responseDataMode: ResponseDataMode.realData,
      response: response,
      converter: null,
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
