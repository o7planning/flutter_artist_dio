part of '../../../flutter_artist_dio.dart';

/// The sovereign composite data ledger mapping and orchestrating the entire
/// unified lifecycle metadata records of a singular HTTP transaction.
///
/// It acts as a centralized tracking hub, securely binding independent data structures
/// ([RequestLogData], [ResponseLogData], and [ErrorLogData]) under a unique sequence key tracking context.
/// It encapsulates specific token extractions (e.g., `Authorization` tokens) and handles late-stage
/// presentation data evaluation logic mapping safely onto display grids.
class ApiLogData {
  /// The unique sequence identifier token mapping this specific transaction inside the local memory buffer database.
  late final int apiLogId;

  /// The cached raw security token string extracted straight from the outbound request headers collection.
  String? _authorization;

  /// Exposes the extracted raw security token string assigned to this request transaction sequence.
  String? get authorization => _authorization;

  /// Internal reference holding the successfully resolved inbound network response telemetry snapshot.
  ResponseLogData? _responseLogData;

  /// Internal reference holding the parsed network connection failure or bad status code exception blueprint.
  ErrorLogData? _errorLogData;

  /// The master outbound connection layout metrics and parameters initialized at interceptor injection steps.
  late final RequestLogData requestLogData;

  /// Returns the structural response snapshot database record if the monitored HTTP request resolved successfully.
  ResponseLogData? get responseLogData => _responseLogData;

  /// Returns the structural exception blueprint log record if the monitored HTTP transaction aborted.
  ErrorLogData? get errorLogData => _errorLogData;

  /// Exposes the post-response downstream semantic conversation failure model asset, if populated.
  ApiError? get conversationError => _conversationError;

  /// Internal secondary semantic domain-level application execution exception layer.
  ///
  /// This error tracks situations where the HTTP layer connected successfully (e.g., 200 OK),
  /// but downstream application processing rules failed inside business conversation pipelines.
  ApiError? _conversationError;

  /// Internal private initializer constructing a pure declarative [ApiLogData] ledger container tracking node.
  ApiLogData._(this.apiLogId, RequestOptions options) {
    requestLogData = RequestLogData(
      options: options,
    );
    _authorization = options.headers["Authorization"];
  }

  /// Calculates the active network round-trip delay duration and processes
  /// the transaction speed metrics into a human-readable plain text format layout.
  ///
  /// Mapped under a fixed mathematical string format rule: `"$seconds.$milliseconds (Seconds)"`.
  String getResponseTimeAsString() {
    int millis =
        _responseLogData?.responseTime ?? _errorLogData?.responseTime ?? 0;
    int s = millis ~/ 1000;
    int ms = millis % 1000;
    return "$s.$ms (Seconds)";
  }

  /// Reconciles and extracts the applicable active failed data asset generated down the pipeline.
  ///
  /// Prioritizes structural low-level [ErrorLogData] mappings first before falling back
  /// to evaluate the internal downstream application [conversationError] references.
  ApiError? getApiError() {
    return _errorLogData?.toApiError() ?? conversationError;
  }

  /// Evaluation indicator indicating whether this transaction tracking node contains
  /// low-level transport errors or secondary high-level domain conversation pipeline failures.
  bool get hasError => _errorLogData != null || _conversationError != null;

  /// Safely extracts the absolute plain-text string representation layout resolved
  /// from the internal active data stream layer.
  ///
  /// Automatically branches to crawl across successful response metrics or exception pools dynamically.
  String? getResponseText() {
    if (_responseLogData != null) {
      return _responseLogData!.getResponseText();
    } else if (_errorLogData != null) {
      return _errorLogData!.getResponseText();
    } else {
      return null;
    }
  }

  /// Safely decodes and returns the authentic parsed JSON object map or list array configuration
  /// extracted out of the raw available body stream.
  Object? getRealJsonObjOrArray() {
    if (_responseLogData != null) {
      return _responseLogData!.getRealJsonObjOrArray();
    } else if (_errorLogData != null) {
      return _errorLogData!.getRealJsonObjOrArray();
    } else {
      return null;
    }
  }

  /// Evaluates and dictates whether the inbound response payload completely lacks structured text or body elements.
  bool hasNoResponseData() {
    return _responseLogData == null && _errorLogData == null;
  }

  /// Injects the successfully parsed inbound network response record snapshot directly into this ledger node.
  void _setResponseInfo(ResponseLogData responseInfo) {
    _responseLogData = responseInfo;
  }

  /// Injects the parsed network connection exception or bad response metadata blueprint directly into this ledger node.
  void _setErrorInfo(ErrorLogData errorInfo) {
    _errorLogData = errorInfo;
  }

  /// Registers a custom downstream domain-level conversation application failure token reference.
  void _setConversationError(ApiError? apiError) {
    _conversationError = apiError;
  }

  /// Injects a transformed custom [ApiError] override configuration straight down into the child exception mapping node.
  void _setApiError(ApiError apiError) {
    _errorLogData?._setApiError(apiError);
  }
}
