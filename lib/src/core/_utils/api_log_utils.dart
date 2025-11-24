import 'package:dio/dio.dart';

import '../../../flutter_artist_dio.dart';

class ApiLogUtils {
  static const String _requestKey = "-extra-flutter-artist-request-";

  static ApiLogData createApiLogData(RequestOptions options) {
    ApiLogData apiLogData = ApiLogData(options);
    options.extra[_requestKey] = apiLogData;
    return apiLogData;
  }

  static ApiLogData? getApiLogData(RequestOptions options) {
    return options.extra[_requestKey];
  }
}
