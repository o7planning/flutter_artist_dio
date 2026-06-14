import 'dart:convert';

/// The internal shared state encoder configured with
/// a uniform three-space indentation layout rule.
var _encoder = const JsonEncoder.withIndent("   ");

/// Standard utility mapping that converts an un-formatted generic object payload
/// into a structured, highly human-readable formatted JSON [String].
///
/// Returns `null` if the incoming payload fails serialization constraints.
String? toBeautifulJson(Object jsonObj) {
  try {
    return _encoder.convert(jsonObj);
  } catch (e) {
    return null;
  }
}

/// Legacy fallback encoder utility method built to process and format loose data maps,
/// lists, or pre-encoded dynamic JSON string layers securely.
String toBeautifulJsonOLD(dynamic data) {
  if (data == null) {
    return "";
  }
  try {
    if (data is Map) {
      return _encoder.convert(data);
    }
    if (data is List) {
      return _encoder.convert(data);
    }
    if (data is String) {
      dynamic obj = jsonDecode(data);
      return _encoder.convert(obj);
    }
  } catch (e) {}
  return data.toString();
}
