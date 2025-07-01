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
  //
  // Map<String,dynamic> or List<dynamic> or String.
  //
  dynamic errorData;
  int status;
  String? errorMessage;
  if (error.response != null) {
    errorData = error.response!.data;
    status = error.response!.statusCode ?? -1;
    errorMessage = error.response!.statusMessage ?? "Unknown Error";
  } else {
    errorData = null;
    status = -1;
    errorMessage = "Unknown error: $error";
  }
  //
  ApiResult<D> apiResult = ApiResult<D>.error(
    apiErrorType: apiErrorType,
    status: status.toString(),
    errorMessage: errorMessage,
    errorDetails: null,
    errorData: errorData,
  );
  //
  ApiError apiError = apiResult.toApiError()!;
  //
  info?._setError(apiError);
  //
  return apiResult;
}
