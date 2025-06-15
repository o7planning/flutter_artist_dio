part of '../../../flutter_artist_dio.dart';

ApiResult<D> _handleException<D>(
  dynamic e, {
  required StackTrace? stackTrace,
  required int restRequestId,
  required bool showDebug,
}) {
  print(stackTrace);
  String errorMessage;
  if (e is Exception) {
    errorMessage = "Error: ${e.toString()}";
  } else {
    errorMessage = "Unknown Error: ${e.toString()}";
  }
  if (showDebug) {
    print(errorMessage);
  }
  //
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);

  info?.setErrorInfo(
    dioRequestID: restRequestId,
    error: e,
  );
  return ApiResult(errorMessage: errorMessage);
}
