part of '../../flutter_artist_dio.dart';

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

  //
  int? responseStatusCode;
  String? responseStatusMessage;

  bool __jsonDataReady = false;
  bool __hasNoResponseData = false;
  Object? __responseJsonData;
  String? __responseText;
  dynamic responseData;

  // (0)
  String? errorMessage;

  // (2)
  String? responseErrorMessage;
  List<String>? responseErrorDetails;

  // (3)
  dynamic mainData;
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

  void __convertResponse() {
    if (!__jsonDataReady) {
      // Response Null.
      if (responseData == null) {
        __responseJsonData = null;
        __responseText = null;
        __hasNoResponseData = true;
      }
      // String
      else if (responseData is String) {
        __responseText = responseData;
        __responseJsonData = __jsonDecode(responseData);
        if (__responseJsonData != null) {
          String? json = toBeautifulJson(__responseJsonData!);
          if (json != null) {
            __responseText = json;
          }
        }
        __hasNoResponseData = false;
      }
      // List or Map:
      else if (responseData is List || responseData is Map) {
        __responseJsonData = responseData;
        __responseText = toBeautifulJson(__responseJsonData!);
        __hasNoResponseData = false;
      }
      // Others:
      else {
        __responseJsonData = null;
        __responseText = null;
        __hasNoResponseData = false;
      }
      __jsonDataReady = true;
    }
  }

  bool hasNoResponseData() {
    return __hasNoResponseData;
  }

  Object? toResponseJson() {
    __convertResponse();
    return __responseJsonData;
  }

  String? toResponseText() {
    __convertResponse();
    return __responseText;
  }

  Object? __jsonDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      return null;
    }
  }

  bool get isError {
    return errorType != ErrorType.none;
  }

  // The Server return data.
  void _setResponseSuccessInfo({
    required int dioRequestID,
    required dynamic responseData,
    required int? responseStatusCode,
    required String? responseStatusMessage,
  }) {
    assert(this.dioRequestID == dioRequestID);
    //
    this.responseStatusCode = responseStatusCode;
    this.responseStatusMessage = responseStatusMessage;
    this.responseData = responseData;
  }

  // The Server return error data.
  void _setResponseFailInfo({
    required int dioRequestID,
    required ErrorType errorType,
    required dynamic responseData,
    required int? responseStatusCode,
    required String? responseStatusMessage,
  }) {
    assert(this.dioRequestID == dioRequestID);
    //
    this.errorType = errorType;
    this.responseStatusCode = responseStatusCode;
    this.responseStatusMessage = responseStatusMessage;
    this.responseData = responseData;
  }

  void _setErrorParsingJson({
    required String? errorParsingJsonMessage,
  }) {
    errorType = ErrorType.parseError;
    errorMessage = errorParsingJsonMessage;
  }

  void _setResponseErrorMessage({
    required ErrorType errorType,
    required String? responseErrorMessage,
    required List<String>? responseErrorDetails,
  }) {
    this.errorType = errorType;
    this.responseErrorMessage = responseErrorMessage;
    this.responseErrorDetails = responseErrorDetails;
  }

  void setErrorInfo({
    required int dioRequestID,
    required dynamic error,
  }) {
    print("-- setErrorInfo: $dioRequestID");
    assert(this.dioRequestID == dioRequestID);
    this.error = error;
  }
}
