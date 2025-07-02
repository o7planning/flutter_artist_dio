part of '../../flutter_artist_dio.dart';

ApiResult<D> _handleException<D>(
  dynamic error, {
  required StackTrace? stackTrace,
  required int restRequestId,
  required bool showDebug,
}) {
  print(stackTrace);
  AppError appError = ErrorUtils.toAppError(error);
  //
  if (showDebug) {
    print(appError.errorMessage);
  }
  //
  ApiResult<D> apiResult = ApiResult<D>.apiError(
    ApiError(
      statusCode: null,
      apiErrorType: ApiErrorType.unknown,
      errorMessage: appError.errorMessage,
      errorDetails: appError.errorDetails,
      originErrorText: null,
    ),
  );
  //
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  info?._setError(apiResult.apiError!);
  //
  return apiResult;
}
