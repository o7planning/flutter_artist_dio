part of '../../../flutter_artist_dio.dart';

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
Future<ApiResult<D>> _jsonPost<D>(
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
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
}) async {
  try {
    final response = await dio.post(
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
      responseDataMode: responseDataMode,
      response: response,
      converter: converter,
    );
  } on DioException catch (e, stackTrace) {
    return _handleDioException(e, stackTrace: stackTrace);
  } catch (e, stackTrace) {
    return _handleException(e, stackTrace: stackTrace);
  }
}
