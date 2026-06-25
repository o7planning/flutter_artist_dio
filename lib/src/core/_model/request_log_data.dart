part of '../../../flutter_artist_dio.dart';

/// An immutable operational snapshot blueprint mapping outbound HTTP connection
/// telemetry data captured straight from the interceptor layer.
///
/// It extracts and structures metadata properties from a raw third-party [RequestOptions] object,
/// including method verbs, headers, custom extra attributes, and seamlessly unifies complex
/// payloads (such as multi-part [FormData], raw string bodies, or nested maps) into a single
/// accessible lookup framework profile.
class RequestLogData {
  /// The foundational endpoint remote engine host path (e.g., 'https://api.example.com').
  late final String baseUrl;

  /// The fully resolved target endpoint location locator token package representation layer.
  late final Uri uri;

  /// The active HTTP interaction method verb role applied to this execution sequence (e.g., GET, POST).
  late final String method;

  /// The filtered collection matrix bocking all operational header elements attached onto the outbound request.
  ///
  /// This ledger includes internal transmission rules such as timeout metrics,
  /// redirect validation markers, and explicit payload content types.
  late final Map<String, dynamic> requestHeaders;

  /// The explicit key-value parameters parsed directly out of the targeted connection URL query sequence.
  late final Map<String, dynamic> queryParameters;

  /// A custom metadata storage storage matrix enabling third-party developers to pass loose,
  /// non-standard connection context flags down the filter pipeline.
  late final Map<String, dynamic> extra;

  /// The unparsed, raw generic content body token assigned onto the outbound data channel.
  late final dynamic data;

  /// A normalized structured key-value index map containing the serialized, fully readable representation of [data].
  ///
  /// This parameter abstracts away low-level body data formats, offering identical data access vectors
  /// regardless of whether the original transaction payload was a raw JSON map string or a multi-part [FormData].
  late final Map<String, dynamic> mapData;

  /// Instantiates a pure declarative [RequestLogData] tracking capsule by extracting properties
  /// directly from an active [RequestOptions] instance wrapper.
  RequestLogData({
    required RequestOptions options,
  }) {
    baseUrl = options.baseUrl;
    uri = options.uri;
    method = options.method;
    //
    requestHeaders = <String, dynamic>{};
    requestHeaders.addAll(options.headers);
    if (options.contentType != null) {
      requestHeaders['contentType'] = options.contentType?.toString();
    }
    requestHeaders['responseType'] = options.responseType.toString();
    requestHeaders['followRedirects'] = options.followRedirects;
    if (options.connectTimeout != null) {
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
    }
    if (options.receiveTimeout != null) {
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
    }
    //
    queryParameters = options.queryParameters;
    extra = Map.of(options.extra);
    data = options.data;
    //
    mapData = {};

    if (data != null) {
      if (data is FormData) {
        for (final e in data.fields) {
          if (mapData.containsKey(e.key)) {
            if (mapData[e.key] is List) {
              mapData[e.key].add(e.value);
            } else {
              mapData[e.key] = [
                mapData[e.key],
                e.value,
              ];
            }
          } else {
            mapData[e.key] = e.value;
          }
        }
        for (final e in data.files) {
          mapData[e.key] = "<MultipartFile>";
        }
      } else if (data is Map<String, dynamic>) {
        mapData.addAll(data);
      } else if (data is Map<dynamic, dynamic>) {
        mapData.addAll(Map<String, dynamic>.from(data));
      } else if (data is String) {
        final json = jsonDecode(data);
        if (json is Map<String, dynamic>) {
          mapData.addAll(json);
        } else {
          mapData["data"] = json;
        }
      } else if (data is List) {
        mapData["data"] = data;
      } else if (data is Uint8List) {
        mapData["data"] = "<Uint8List length=${data.length}>";
      } else if (data is List<int>) {
        mapData["data"] = "<List<int> length=${data.length}>";
      } else if (data is Stream<List<int>>) {
        mapData["data"] = "<Stream<List<int>>>";
      } else {
        mapData["data"] = "<${data.runtimeType}>";
      }
    }
  }

// // TODO:
// void _data(RequestOptions options) {
//   if (data != null) {
//     if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
//     if (data is FormData) {
//       final dataMap = <String, dynamic>{}
//         ..addEntries(data.fields)
//         ..addEntries(data.files);
//       _printMapAsTable(dataMap, header: 'Form data | ${data.boundary}');
//     } else {
//       _printBlock(data.toString());
//     }
//   }
// }
}
