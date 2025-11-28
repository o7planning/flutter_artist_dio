part of '../flutter_artist_dio.dart';

const _timeStampKey = '_pdl_timeStamp_';

class FlutterArtistDioLoggerInterceptor extends QueuedInterceptor {
  FlutterArtistDioLoggerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_timeStampKey] = DateTime.timestamp().millisecondsSinceEpoch;
    final apiLogData = ApiLogUtils.createApiLogData(options);
    apiLogger._addApiLogData(apiLogData);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final triggerTime = err.requestOptions.extra[_timeStampKey];
    int responseTime = 0;
    if (triggerTime is int) {
      responseTime = DateTime.timestamp().millisecondsSinceEpoch - triggerTime;
    }
    final ApiLogData? apiLogData =
        ApiLogUtils.getApiLogData(err.requestOptions);
    final errorInfo = ErrorLogData(err, responseTime);
    apiLogData?._setErrorInfo(errorInfo);
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ApiLogData? apiLogData =
        ApiLogUtils.getApiLogData(response.requestOptions);
    final triggerTime = response.requestOptions.extra[_timeStampKey];

    int responseTime = 0;
    if (triggerTime is int) {
      responseTime = DateTime.timestamp().millisecondsSinceEpoch - triggerTime;
    }
    //
    final responseInfo = ResponseLogData(
      response: response,
      responseTime: responseTime,
    );
    apiLogData?._setResponseInfo(responseInfo);
    handler.next(response);
  }
}