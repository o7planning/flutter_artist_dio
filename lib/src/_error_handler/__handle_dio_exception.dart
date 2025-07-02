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

  String? originErrorText;
  int statusCode;
  String? errorMessage;
  if (error.response != null) {
    dynamic errorData = error.response!.data;
    ApiError apiError = ApiError.fromResponseErrorData(
      statusCode: error.response!.statusCode,
      statusMessage: error.response!.statusMessage,
      responseErrorData: errorData,
    );
    originErrorText = apiError.originErrorText;
    statusCode = error.response!.statusCode ?? -1;
    errorMessage = error.response!.statusMessage ?? "Unknown Error";
  } else {
    originErrorText = null;
    statusCode = -1;
    errorMessage = "Unknown error: $error";
  }
  //
  ApiResult<D> apiResult = ApiResult<D>.error(
    apiErrorType: apiErrorType,
    statusCode: statusCode,
    errorMessage: errorMessage,
    errorDetails: null,
    originErrorText: originErrorText,
  );
  //
  ApiError apiError = apiResult.toApiError()!;
  //
  info?._setError(apiError);
  //
  return apiResult;
}
