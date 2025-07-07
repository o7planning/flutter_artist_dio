part of '../../flutter_artist_dio.dart';

class JsonConversionErrorDetector {
  final Function(Map<String, dynamic>) converter;
  final Object jsonOBJ;

  JsonConversionErrorDetector({required this.converter, required this.jsonOBJ});

  Object? miniatureTheErrorRange() {
    _Wrap wrapJsonOBJ;
    if (jsonOBJ is Map<String, dynamic>) {
      wrapJsonOBJ = _Wrap.fromMap(jsonOBJ as Map<String, dynamic>);
    } else if (jsonOBJ is List<dynamic>) {
      wrapJsonOBJ = _Wrap.fromList(jsonOBJ as List<dynamic>);
    } else {
      return null;
    }
    bool isError = _isConversionError(wrapJsonOBJ);
    if (!isError) {
      throw AppError(
          errorMessage:
              "There is no JSON conversion error to Object and vice versa.");
    }
    while (true) {
      _Wrap? w = __find(wrapJsonOBJ);
      if (w == null) {
        break;
      }
      w.include = false;
      bool error = _isConversionError(wrapJsonOBJ);
      if (!error) {
        w.include = true;
        w.tested = true;
      }
    }
    return wrapJsonOBJ.toJsonObjOrArrayOrValue();
  }

  bool _isConversionError(_Wrap wrapJsonOBJ) {
    try {
      dynamic jsonOBJ = wrapJsonOBJ.toJsonObjOrArrayOrValue();
      converter(jsonOBJ);
      return false;
    } catch (e) {
      return true;
    }
  }

  _Wrap? __find(_Wrap wrap) {
    if (wrap is _WrapList) {
      _WrapList wrapList = wrap as _WrapList;
      for (_Wrap childWrap in wrapList.list) {
        if (!childWrap.tested && childWrap.include) {
          return childWrap;
        }
      }
      for (_Wrap childWrap in wrapList.list) {
        if (childWrap.tested && childWrap.include) {
          _Wrap? w = __find(childWrap);
          if (w != null) {
            return w;
          }
        }
      }
    } else if (wrap is _WrapMap) {
      _WrapMap wrapMap = wrap as _WrapMap;
      for (_Wrap childWrap in wrapMap.map.values) {
        _Wrap? w = __find(childWrap);
        if (w != null) {
          return w;
        }
      }
    } else {
      return null;
    }
  }
}
