part of '../../../flutter_artist_dio.dart';

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
Future<ApiResult<List<int>?>> _binaryGet(
  Dio dio,
  String path, {
  bool showDebug = false,
  //
  ProgressCallback? onReceiveProgress,
  Map<String, dynamic>? queryParameters,
  CancelToken? cancelToken,
  Object? data,
  Options? options,
}) async {
  try {
    // Make a GET request to fetch the file data as bytes.
    final Response<List<int>> response = await dio.get<List<int>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return ApiResult.success(data: response.data);
  } on DioException catch (e, stackTrace) {
    return _handleDioException(e, stackTrace: stackTrace);
  } catch (e, stackTrace) {
    return _handleException(e, stackTrace: stackTrace);
  }
}
