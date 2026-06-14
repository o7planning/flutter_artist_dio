part of '../../../flutter_artist_dio.dart';

/// An immutable operational snapshot blueprint mapping inbound HTTP response
/// telemetry data captured straight from the interceptor layer.
///
/// It extracts and structures validation properties from a raw third-party [Response] object,
/// managing status codes, network round-trip delays, and header lists. It leverages
/// an advanced lazy parsing strategy to inspect payload bodies only upon active demand.
class ResponseLogData {
  /// The fully resolved target endpoint location locator token package representation layer.
  late final Uri uri;

  /// The active HTTP interaction method verb role executed for this transaction sequence (e.g., GET, POST).
  late final String method;

  /// The standard HTTP response status code integer returned by the remote host, if available.
  late final int? statusCode;

  /// The human-readable status reason phrase string responded back by the remote destination engine.
  late final String? statusMessage;

  /// The unparsed, raw generic content body payload data returned inside the inbound response channel.
  late final dynamic data;

  /// The round-trip execution duration speed measured in milliseconds for the entire transaction life.
  final int responseTime;

  /// A normalized, flattened lookup dictionary containing all raw string headers responded by the server.
  late final Map<String, String> responseHeaders;

  /// Internal lazy-cached metadata structural analyzer container for deep string/json extractions.
  DetailedData? __detailedData;

  /// Instantiates a pure declarative [ResponseLogData] tracking capsule by extracting metrics
  /// directly from an active [Response] instance wrapper.
  ResponseLogData({
    required Response response,
    required this.responseTime,
  }) {
    uri = response.requestOptions.uri;
    method = response.requestOptions.method;
    statusCode = response.statusCode;
    statusMessage = response.statusMessage;
    data = response.data;
    //
    responseHeaders = <String, String>{};
    response.headers.forEach((k, list) {
      if (list.isEmpty) {
        responseHeaders[k] = "";
      } else if (list.length == 1) {
        responseHeaders[k] = list.first.toString();
      } else {
        responseHeaders[k] = list.toString();
      }
    });
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

  /// Lazily extracts the absolute plain-text string representation layout resolved from the raw response body stream.
  String? getResponseText() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.text;
  }
}
