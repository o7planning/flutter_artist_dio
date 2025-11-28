part of '../../../flutter_artist_dio.dart';

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
  required ErrorInfoExtractor errorInfoExtractor,
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
  try {
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
    );
  } on DioException catch (e, stackTrace) {
    return _handleDioException(
      e,
      stackTrace: stackTrace,
      errorInfoExtractor: errorInfoExtractor,
    );
  } catch (e, stackTrace) {
    return _handleException(e, stackTrace: stackTrace);
  }
}
