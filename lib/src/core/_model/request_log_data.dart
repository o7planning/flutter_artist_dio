part of '../../../flutter_artist_dio.dart';

class RequestLogData {
  late final String baseUrl;
  late final Uri uri;
  late final String method;

  late final Map<String, dynamic> requestHeaders;
  late final Map<String, dynamic> queryParameters;
  late final Map<String, dynamic> extra;
  late final dynamic data;
  late Map<String, dynamic> mapData;

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
        for (MapEntry<String, String> e in data.fields) {
          mapData[e.key] = e.value;
        }
      } else if (data is Map<String, dynamic>) {
        mapData.addAll(data);
      } else if (data is Map<dynamic, dynamic>) {
        mapData.addAll({});
      } else if (data is String) {
        mapData.addAll(jsonDecode(data));
      } else {
        print(">>>>>>>>> TODO: $data --> type: ${data.runtimeType}");
        throw Error();
      }
    }
  }

  // TODO:
  void _data(RequestOptions options) {
    // if (data != null) {
    //   if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
    //   if (data is FormData) {
    //     final dataMap = <String, dynamic>{}
    //       ..addEntries(data.fields)
    //       ..addEntries(data.files);
    //     _printMapAsTable(dataMap, header: 'Form data | ${data.boundary}');
    //   } else {
    //     _printBlock(data.toString());
    //   }
    // }
  }
}
