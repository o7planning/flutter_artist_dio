part of '../../../flutter_artist_dio.dart';

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
  required ErrorInfoExtractor errorInfoExtractor,
}) {
  print("Error: $error");
  print(stackTrace);
  //
  final ApiErrorType apiErrorType = DioErrorUtils.toApiErrorType(error.type);

  final ApiError apiError;
  if (error.response != null) {
    apiError = DioErrorUtils.parseErrorResponse(
      errorResponse: error.response!,
      apiErrorType: apiErrorType,
      errorInfoExtractor: errorInfoExtractor,
    );
  } else {
    final dynamic internalError = error.error;

    // 1. Check specifically for FormatException to get the raw source
    final bool isParsingError = internalError is FormatException;

    // 2. Extract the raw text that failed to parse
    String? rawText;
    if (internalError is FormatException) {
      // .source contains the actual string the server sent
      rawText = internalError.source?.toString();
    }
    apiError = ApiError(
      errorType: apiErrorType,
      statusCode: null,
      statusMessage: null,
      errorMessage: isParsingError
          ? rawText == null
              ? "Format Error: The server returned a text message that isn't valid JSON."
              : "Raw Response: $rawText"
          : (error.message ?? "Unknown Dio Error"),
      originErrorText: rawText,
    );
  }
  //
  ApiLogData? apiLogData = ApiLogUtils.getApiLogData(error.requestOptions);
  apiLogData?._setApiError(apiError);
  //
  ApiResult<D> apiResult = ApiResult<D>.fromError(apiError);
  return apiResult;
}
