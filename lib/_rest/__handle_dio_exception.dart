part of '../flutter_artist_dio.dart';

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
  String? errorCause;

  RequestLogInfo? info = restLogger.getRequestLogInfo(restRequestId);

  info?.setErrorInfo(
    dioRequestID: restRequestId,
    error: error,
  );

  //
  if (error.response != null) {
    // Map<String,dynamic> or List<dynamic> or String.
    var errorData = error.response!.data;

    //

    info?.setResponseFailInfo(
      dioRequestID: restRequestId,
      isNoResponse: false,
      responseData: errorData,
      responseStatusCode: error.response!.statusCode,
      responseStatusMessage: error.response!.statusMessage,
    );

    if (showDebug) {
      print(
          'Dio Error: ${error.response!.statusCode}: ${error.response!.statusMessage}');
      print("Error Data: $errorData");
    }

    try {
      WrapApiResult? baseResult = WrapApiResult.fromDynamicData(errorData);
      if (baseResult == null) {
        info?.setErrorParsingJson(
          errorParsingJson: true,
          errorParsingJsonMessage: "Response Error JSON is not valid!",
        );
        if (showDebug) {
          print("Response Error JSON is not valid!");
        }
        return ApiResult(errorMessage: "Response Error JSON is not valid!");
      } else {
        info?.setErrorParsingJson(
          errorParsingJson: false,
          errorParsingJsonMessage: "Response Error JSON is valid!",
        );
      }
      info?.setResponseErrorMessage(
        responseErrorMessage: baseResult.errorMessage,
        responseErrorDetails: baseResult.errorDetails,
      );
      return ApiResult(
        errorMessage: baseResult.errorMessage,
        errorDetails: baseResult.errorDetails,
      );
    } catch (e) {
      // --------------------------------------------->
      info?.setErrorParsingJson(
        errorParsingJson: true,
        errorParsingJsonMessage: "Error Parsing JSON: $e",
      );
      print("----------- $errorData");
      return ApiResult(errorMessage: "Error Parsing JSON: $e");
    }
  } else {
    info?.setResponseFailInfo(
      dioRequestID: restRequestId,
      isNoResponse: true,
      responseData: null,
      responseStatusCode: -1,
      responseStatusMessage: null,
    );

    // Handle no response
    String errorMessage = "No Response: $error";
    if (showDebug) {
      print(errorMessage);
    }
    info?.setResponseErrorMessage(
      responseErrorMessage: errorMessage,
      responseErrorDetails: null,
    );
    return ApiResult(errorMessage: errorMessage);
  }
}
