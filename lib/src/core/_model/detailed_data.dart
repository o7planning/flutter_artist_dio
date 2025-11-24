import 'dart:convert';

import '../_utils/json_utils.dart';

class DetailedData {
  final Object? jsonObjOrArray;
  final String? text;
  final bool noResponse;

  DetailedData({
    required this.jsonObjOrArray,
    required this.text,
    required this.noResponse,
  });

  factory DetailedData.fromData(dynamic data) {
    if (data == null) {
      return DetailedData(
        jsonObjOrArray: null,
        text: null,
        noResponse: true,
      );
    }
    // String
    else if (data is String) {
      Object? jsonObjOrArr = __jsonDecode(data);
      String? respText = data;
      try {
        respText = toBeautifulJson(jsonObjOrArr!);
      } catch (e) {}
      return DetailedData(
        jsonObjOrArray: jsonObjOrArr,
        text: respText,
        noResponse: false,
      );
    }
    // List:
    else if (data is List) {
      return DetailedData(
        jsonObjOrArray: data,
        text: toBeautifulJson(data!),
        noResponse: false,
      );
    }
    // Map
    else if (data is Map) {
      return DetailedData(
        jsonObjOrArray: data,
        text: toBeautifulJson(data!),
        noResponse: false,
      );
    }
    // Others:
    else {
      return DetailedData(
        jsonObjOrArray: null,
        text: data.toString(),
        noResponse: false,
      );
    }
  }

  static Object? __jsonDecode(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      return null;
    }
  }
}
