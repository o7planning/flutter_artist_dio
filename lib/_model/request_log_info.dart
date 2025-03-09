part of '../flutter_artist_dio.dart';

enum ErrorType {
  none,
  noResponse,
  serverSideError,
  clientSideError,
}

class RequestLogInfo {
  int dioRequestID;
  String baseUrl;
  String requestPath;
  String requestMethod;
  String? token;
  late Map<String, dynamic> requestHeaders;
  late Map<String, dynamic> requestQueryParameters;
  late Map<String, dynamic> mapData;

  //
  ErrorType errorType = ErrorType.none;
  bool isNoResponse = false;
  bool isServerSideError = false;
  bool isClientSideError = false;

  //
  int? responseStatusCode;
  String? responseStatusMessage;
  dynamic responseData;

  // (1)
  bool errorParsingJson = false;
  String? errorParsingJsonMessage;

  // (2)
  String? responseErrorMessage;
  List<String>? responseErrorDetails;

  // (3)
  dynamic mainData;
  bool errorConvertingJson = false;
  String? errorConvertingJsonMessage;

  //
  dynamic error;

  RequestLogInfo({
    required this.dioRequestID,
    required this.baseUrl,
    required this.requestPath,
    required this.requestMethod,
    required Map<String, dynamic> requestHeaders,
    required Map<String, dynamic> requestQueryParameters,
    required dynamic formData,
    required this.token,
  }) {
    this.requestHeaders = {};
    this.requestHeaders.addAll(requestHeaders);
    const authKey = 'Authorization';
    if (this.requestHeaders.containsKey(authKey)) {
      String value = this.requestHeaders[authKey];
      this.requestHeaders[authKey] =
          value.length > 20 ? "${value.substring(0, 20)}..." : value;
    }
    this.requestHeaders.remove(_keyDioRequestID);
    //
    this.requestQueryParameters = {};
    this.requestQueryParameters.addAll(requestQueryParameters);
    mapData = {};
    if (formData != null) {
      if (formData is FormData) {
        for (MapEntry<String, String> e in formData.fields) {
          mapData[e.key] = e.value;
        }
      } else if (formData is Map<String, dynamic>) {
        mapData.addAll(formData);
      } else if (formData is Map<dynamic, dynamic>) {
        mapData.addAll({});
      } else if (formData is String) {
        mapData.addAll(jsonDecode(formData));
      } else {
        print(">>>>>>>>> TODO: $formData --> type: ${formData.runtimeType}");
        throw Error();
      }
    }
  }

  bool get isError => isNoResponse || isServerSideError || isClientSideError;

  // Request Successul! The Server return data.
  void setResponseSuccessInfo({
    required int dioRequestID,
    required dynamic responseData,
    required int? responseStatusCode,
    required String? responseStatusMessage,
  }) {
    // print("-- setResponseInfo: $dioRequestID");
    assert(this.dioRequestID == dioRequestID);
    isNoResponse = false;
    isServerSideError = false;
    this.responseStatusCode = responseStatusCode;
    this.responseStatusMessage = responseStatusMessage;
    this.responseData = responseData;
  }

  // Request Fail! The Server return error data.
  void setResponseFailInfo({
    required int dioRequestID,
    required bool isNoResponse,
    required dynamic responseData,
    required int? responseStatusCode,
    required String? responseStatusMessage,
  }) {
    // print("-- setResponseInfo: $dioRequestID");
    assert(this.dioRequestID == dioRequestID);
    isServerSideError = true;
    this.isNoResponse = isNoResponse;
    this.responseStatusCode = responseStatusCode;
    this.responseStatusMessage = responseStatusMessage;
    this.responseData = responseData;
  }

  void setErrorParsingJson({
    required bool errorParsingJson,
    required String? errorParsingJsonMessage,
  }) {
    this.errorParsingJson = errorParsingJson;
    this.errorParsingJsonMessage = errorParsingJsonMessage;
  }

  void setErrorConvertingJson({
    required dynamic mainData,
    required bool errorConvertingJson,
    required String? errorConvertingJsonMessage,
  }) {
    this.mainData = mainData;
    this.errorConvertingJson = errorConvertingJson;
    this.errorConvertingJsonMessage = errorConvertingJsonMessage;
  }

  void setResponseErrorMessage({
    required String? responseErrorMessage,
    required List<String>? responseErrorDetails,
  }) {
    this.responseErrorMessage = responseErrorMessage;
    this.responseErrorDetails = responseErrorDetails;
  }

  void setErrorInfo({
    required int dioRequestID,
    required dynamic error,
  }) {
    print("-- setErrorInfo: $dioRequestID");
    assert(this.dioRequestID == dioRequestID);
    this.isNoResponse = false;
    this.error = error;
  }
}
