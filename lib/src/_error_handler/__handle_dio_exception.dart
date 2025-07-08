part of '../../flutter_artist_dio.dart';

//
// switch (error.type) {
//   case DioExceptionType.connectionTimeout:
//   case DioExceptionType.sendTimeout:
//   case DioExceptionType.receiveTimeout:
//     errorCause = "Timeout occurred while sending or receiving";
//   case DioExceptionType.badResponse:
//     final statusCode = error.response?.statusCode;
//     if (statusCode != null) {
//       switch (statusCode) {
//         case StatusCode.badRequest:
//           errorCause = "Bad Request";
//         case StatusCode.unauthorized:
//         case StatusCode.forbidden:
//           return "Unauthorized";
//         case StatusCode.notFound:
//           return "Not Found";
//         case StatusCode.conflict:
//           return 'Conflict';
//         case StatusCode.internalServerError:
//           return "Internal Server Error";
//       }
//     }
//     break;
//   case DioExceptionType.cancel:
//     break;
//   case DioExceptionType.unknown:
//     return "No Internet Connection";
//   case DioExceptionType.badCertificate:
//     return "Internal Server Error";
//   case DioExceptionType.connectionError:
//     return "Connection Error";
//   default:
//     return "Unknown Error";
// }
//
ApiResult<D> _handleDioException<D>(
  DioException error, {
  required StackTrace? stackTrace,
  required int restRequestId,
  required bool showDebug,
}) {
  print(stackTrace);
  //
  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);
  //
  final ApiErrorType apiErrorType =
      DioExceptionUtils.toApiErrorType(error.type);

  ApiError apiError;
  if (error.response != null) {
    info?._setResponseInfo(
      dioRequestID: restRequestId,
      responseData: error.response!.data,
      responseStatusCode: error.response!.statusCode,
      responseStatusMessage: error.response!.statusMessage,
    );
    //
    apiError = ApiError.fromResponseErrorData(
      apiErrorType: apiErrorType,
      statusCode: error.response!.statusCode,
      statusMessage: error.response!.statusMessage,
      responseErrorData: error.response!.data,
    );
  } else {
    apiError = ApiError(
      apiErrorType: apiErrorType,
      statusCode: null,
      statusMessage: null,
      errorMessage: "Error: $error",
      originErrorText: null,
    );
  }
  //
  ApiResult<D> apiResult = ApiResult<D>.apiError(apiError);
  //
  info?._setError(apiResult.apiError!);
  //
  return apiResult;
}
