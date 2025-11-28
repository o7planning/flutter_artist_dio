part of '../../../flutter_artist_dio.dart';

class ErrorLogData {
  final int responseTime;
  late final int? statusCode;
  late final String? statusMessage;
  late final dynamic data;
  late final ApiErrorType apiErrorType;

  DetailedData? __detailedData;
  ApiError? _apiError;

  ErrorLogData(DioException err, this.responseTime) {
    statusCode = err.response?.statusCode;
    statusMessage = err.response?.statusMessage;
    apiErrorType = DioErrorUtils.toApiErrorType(err.type);
    data = err.response?.data;
  }

  void _setApiError(ApiError apiError) {
    _apiError = apiError;
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

  ApiError toApiError() {
    return _apiError ??
        ApiError(
          statusCode: statusCode,
          statusMessage: statusMessage,
          errorType: apiErrorType,
          originErrorText: getResponseText(),
          errorMessage: "Uknown Error",
          errorDetails: null,
          usedConverter: null,
        );
  }
}
