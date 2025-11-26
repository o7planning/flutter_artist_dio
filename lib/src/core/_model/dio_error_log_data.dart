part of '../../../flutter_artist_dio.dart';

class DioErrorLogData {
  final int responseTime;
  late final int? statusCode;
  late final String? statusMessage;
  late final dynamic data;
  late final ApiErrorType apiErrorType;

  DetailedData? __detailedData;

  DioErrorLogData(DioException err, this.responseTime) {
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

  ApiError toApiError() {
    return ApiError(
      statusCode: statusCode,
      statusMessage: statusMessage,
      errorType: apiErrorType,
      originErrorText: getResponseText(),
      errorMessage: _getErrorMessage(),
      errorDetails: _getErrorDetails(),
      usedConverter: null,
    );
  }

  String _getErrorMessage() {
    return "TODO-1";
  }

  List<String>? _getErrorDetails() {
    return ["TODO-2"];
  }
}
