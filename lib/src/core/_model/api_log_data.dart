part of '../../../flutter_artist_dio.dart';

int __apiLogSequence = 1;

class ApiLogData {
  late final int apiLogId;

  String? _authorization;

  String? get authorization => _authorization;

  ResponseLogData? _responseLogData;
  ErrorLogData? _errorLogData;

  late final RequestLogData requestLogData;

  ResponseLogData? get responseLogData => _responseLogData;

  ErrorLogData? get errorLogData => _errorLogData;

  ApiError? get conversationError => _conversationError;

  // Conversation error:
  ApiError? _conversationError;

  ApiLogData(RequestOptions options) {
    apiLogId = __apiLogSequence++;
    requestLogData = RequestLogData(
      options: options,
    );
    _authorization = options.headers["Authorization"];
  }

  String getResponseTimeAsString() {
    int millis =
        _responseLogData?.responseTime ?? _errorLogData?.responseTime ?? 0;
    int s = millis ~/ 1000;
    int ms = millis % 1000;
    return "$s.$ms (Seconds)";
  }

  ApiError? getApiError() {
    return _errorLogData?.toApiError() ?? conversationError;
  }

  bool get hasError => _errorLogData != null || _conversationError != null;

  String? getResponseText() {
    if (_responseLogData != null) {
      return _responseLogData!.getResponseText();
    } else if (_errorLogData != null) {
      return _errorLogData!.getResponseText();
    } else {
      return null;
    }
  }

  Object? getRealJsonObjOrArray() {
    if (_responseLogData != null) {
      return _responseLogData!.getRealJsonObjOrArray();
    } else if (_errorLogData != null) {
      return _errorLogData!.getRealJsonObjOrArray();
    } else {
      return null;
    }
  }

  bool hasNoResponseData() {
    // TODO: Xem lai.
    return _responseLogData == null && _errorLogData == null;
  }

  void _setResponseInfo(ResponseLogData responseInfo) {
    _responseLogData = responseInfo;
  }

  void _setErrorInfo(ErrorLogData errorInfo) {
    _errorLogData = errorInfo;
  }

  // Error after response successful (For example: Conversation error).
  void _setConversationError(ApiError? apiError) {
    _conversationError = apiError;
  }

  void _setApiError(ApiError apiError) {
    _errorLogData?._setApiError(apiError);
  }
}
