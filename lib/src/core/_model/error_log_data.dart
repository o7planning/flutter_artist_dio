part of '../../../flutter_artist_dio.dart';

/// An immutable operational record wrapper encapsulating low-level [DioException]
/// failure properties captured during an aborted HTTP transaction.
///
/// It provides advanced lazy parsing utilities to process network exception states,
/// decode raw payload response maps, and seamlessly construct ecosystem-pure [ApiError] mappings.
class ErrorLogData {
  /// The round-trip execution duration speed measured in milliseconds up to the exception trigger tick.
  final int responseTime;

  /// The standard HTTP response status code integer returned by the remote host, if available.
  late final int? statusCode;

  /// The human-readable status reason phrase string responded back by the remote destination engine.
  late final String? statusMessage;

  /// The un-parsed raw generic payload data block returned inside the active error track channel.
  late final dynamic data;

  /// The sanitized platform-agnostic failure token definition classification.
  late final ApiErrorType apiErrorType;

  /// Internal lazy-cached metadata structural analyzer container for deep string/json extractions.
  DetailedData? __detailedData;

  /// Internal override error definition value assigned via custom conversion rules.
  ApiError? _apiError;

  /// Constructs an operational [ErrorLogData] container instance by parsing a raw [DioException].
  ErrorLogData(DioException err, this.responseTime) {
    statusCode = err.response?.statusCode;
    statusMessage = err.response?.statusMessage;
    apiErrorType = DioFaErrorUtils.toApiErrorType(err.type);
    data = err.response?.data;
  }

  /// Assigns a custom transformed [ApiError] override entity token directly onto this logging node.
  void _setApiError(ApiError apiError) {
    _apiError = apiError;
  }

  /// Lazily evaluates and dictates whether the returned payload data block evaluates to an empty layer.
  bool hasNoResponseData() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.noResponse;
  }

  /// Lazily decodes and returns the authentic parsed JSON [Map] or [List] structure
  /// extracted out of the raw response payload body.
  Object? getRealJsonObjOrArray() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.jsonObjOrArray;
  }

  /// Lazily extracts the absolute plain-text string representation layout resolved from the raw error body stream.
  String? getResponseText() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.text;
  }

  /// Reconciles and transforms this log entry directly into a structured [ApiError] domain asset object.
  ///
  /// Instantly falls back to compiling an anonymous unknown failure payload blueprint
  /// if no tailored converter overrides have been injected via [_setApiError].
  ApiError toApiError() {
    return _apiError ??
        ApiError(
          statusCode: statusCode,
          statusMessage: statusMessage,
          errorType: apiErrorType,
          originErrorText: getResponseText(),
          errorMessage: "Unknown Error",
          errorDetails: null,
          usedConverter: null,
        );
  }
}
