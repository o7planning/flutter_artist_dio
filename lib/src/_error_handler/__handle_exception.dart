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
  ApiResult<D> apiResult = ApiResult<D>.error(
    status: "-1",
    apiErrorType: ApiErrorType.unknown,
    errorMessage: appError.errorMessage,
    errorDetails: appError.errorDetails,
    originText: null,
    errorData: null,
  );
  //
  ApiError apiError = apiResult.toApiError()!;
  //
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  info?._setError(apiError);
  //
  return apiResult;
}
