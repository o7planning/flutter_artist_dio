part of '../flutter_artist_dio.dart';

const _timeStampKey = '_pdl_timeStamp_';

class FlutterArtistDioLoggerInterceptor extends Interceptor {
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
    final errorInfo = DioErrorLogData(err, responseTime);
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
//
// /// Filter arguments
// class FilterArgs {
//   /// If the filter is for a request or response
//   final bool isResponse;
//
//   /// if the [isResponse] is false, the data is the [RequestOptions.data]
//   /// if the [isResponse] is true, the data is the [Response.data]
//   final dynamic data;
//
//   /// Returns true if the data is a string
//   bool get hasStringData => data is String;
//
//   /// Returns true if the data is a map
//   bool get hasMapData => data is Map;
//
//   /// Returns true if the data is a list
//   bool get hasListData => data is List;
//
//   /// Returns true if the data is a Uint8List
//   bool get hasUint8ListData => data is Uint8List;
//
//   /// Returns true if the data is a json data
//   bool get hasJsonData => hasMapData || hasListData;
//
//   /// Default constructor
//   const FilterArgs(this.isResponse, this.data);
// }
