part of '../../../flutter_artist_dio.dart';

class ResponseLogData {
  late final Uri uri;
  late final String method;
  late final int? statusCode;
  late final String? statusMessage;
  late final dynamic data;
  final int responseTime;

  late final Map<String, String> responseHeaders;

  DetailedData? __detailedData;

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

  bool hasNoResponseData() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.noResponse;
  }

  Object? getRealJsonObjOrArray() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.jsonObjOrArray;
  }

  String? getResponseText() {
    __detailedData ??= DetailedData.fromData(data);
    return __detailedData!.text;
  }
}
