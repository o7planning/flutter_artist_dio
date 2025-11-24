part of '../../../flutter_artist_dio.dart';

class ErrorLogData {
  final int responseTime;
  late final int? statusCode;
  late final String? statusMessage;
  late final dynamic data;
  late final ApiErrorType apiErrorType;

  DetailedData? __detailedData;

  ErrorLogData(DioException err, this.responseTime) {
    statusCode = err.response?.statusCode;
    statusMessage = err.response?.statusMessage;
    apiErrorType = DioExceptionUtils.toApiErrorType(err.type);
    data = err.response?.data;
  }

  bool hasNoResponseData() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.noResponse;
  }

  Object? getRealJsonObjOrArray() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.jsonObjOrArray;
  }

  String? getResponseText() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.text;
  }
}
