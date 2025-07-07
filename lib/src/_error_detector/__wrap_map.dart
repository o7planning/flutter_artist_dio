part of '../../flutter_artist_dio.dart';

enum TestState {
  none,
  testing,
  tested;
}

abstract class _Wrap {
  bool include = true;
  bool tested = false;

  dynamic toJsonObjOrArrayOrValue();

  static _Wrap fromMap(Map<String, dynamic> jsonObject) {
    return _WrapMap(jsonObject);
  }

  static _Wrap fromList(List<dynamic> jsonArray) {
    return _WrapList(jsonArray);
  }
}

class _WrapValue extends _Wrap {
  dynamic value;

  _WrapValue(this.value);

  @override
  dynamic toJsonObjOrArrayOrValue() {
    return value;
  }
}

class _WrapMap extends _Wrap {
  late Map<String, _Wrap> map;

  _WrapMap(Map<String, dynamic> jsonObject) {
    map = {};
    for (String key in jsonObject.keys) {
      dynamic value = jsonObject[key];
      _Wrap wrap;
      if (value is Map<String, dynamic>) {
        wrap = _WrapMap(value);
      } else if (value is List<dynamic>) {
        wrap = _WrapList(value);
      } else {
        wrap = _WrapValue(value);
      }
      map[key] = wrap;
    }
  }

  @override
  dynamic toJsonObjOrArrayOrValue() {
    Map<String, dynamic> retMap = {};
    for (String key in map.keys) {
      _Wrap wrapValue = map[key]!;
      if (wrapValue.include) {
        dynamic value = wrapValue.toJsonObjOrArrayOrValue();
        retMap[key] = value;
      }
    }
    return retMap;
  }
}

class _WrapList extends _Wrap {
  late List<_Wrap> list;

  _WrapList(List<dynamic> jsonArray) {
    list = [];
    for (dynamic value in jsonArray) {
      _Wrap wrap;
      if (value is Map<String, dynamic>) {
        wrap = _WrapMap(value);
      } else if (value is List<dynamic>) {
        wrap = _WrapList(value);
      } else {
        wrap = _WrapValue(value);
      }
      list.add(wrap);
    }
  }

  @override
  dynamic toJsonObjOrArrayOrValue() {
    List<dynamic> retList = [];
    for (_Wrap wrapValue in list) {
      if (wrapValue.include) {
        dynamic value = wrapValue.toJsonObjOrArrayOrValue();
        retList.add(value);
      }
    }
    return retList;
  }
}
