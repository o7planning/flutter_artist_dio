part of '../../../flutter_artist_dio.dart';

class _ApiLogHelper {
  static const String _requestKey = "-extra-flutter-artist-request-";

  static ApiLogData createApiLogData(RequestOptions options) {
    ApiLogData apiLogData = ApiLogger.instance._createApiLogData(options);
    options.extra[_requestKey] = apiLogData;
    return apiLogData;
  }

  static ApiLogData? getApiLogData(RequestOptions options) {
    return options.extra[_requestKey];
  }
}
