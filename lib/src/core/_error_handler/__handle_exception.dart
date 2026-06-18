part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleException<D>(
  dynamic error, {
  required StackTrace? stackTrace,
}) {
  print(stackTrace);
  AppError appError = FaErrorUtils.toAppError(error);
  //
  ApiResult<D> apiResult = ApiResult<D>.fromError(
    ApiError(
      statusCode: null,
      errorType: ApiErrorType.unknown,
      errorMessage: appError.errorMessage,
      errorDetails: appError.errorDetails,
      originErrorText: null,
    ),
  );
  //
  return apiResult;
}
