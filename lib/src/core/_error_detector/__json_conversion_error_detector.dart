part of '../../../flutter_artist_dio.dart';

class JsonConversionErrorDetector {
  final Function(Map<String, dynamic>) converter;
  final Object realJsonOBJ;

  JsonConversionErrorDetector({
    required this.converter,
    required this.realJsonOBJ,
  });

  Object? miniatureTheErrorRange() {
    _Wrap wrapJsonOBJ;
    if (realJsonOBJ is Map<String, dynamic>) {
      wrapJsonOBJ = _Wrap.fromMap(realJsonOBJ as Map<String, dynamic>);
    } else if (realJsonOBJ is List<dynamic>) {
      wrapJsonOBJ = _Wrap.fromList(realJsonOBJ as List<dynamic>);
    } else {
      return null;
    }
    final String? conversionErrorOrigin =
        _getConversionErrorMessage(wrapJsonOBJ);
    if (conversionErrorOrigin == null) {
      throw AppError(
          errorMessage:
              "There is no JSON conversion error to Object and vice versa.");
    }
    while (true) {
      _Wrap? w = __find(wrapJsonOBJ, conversionErrorOrigin);
      if (w == null) {
        break;
      }
      w.include = false;
      String? conversionError = _getConversionErrorMessage(wrapJsonOBJ);

      if (conversionError == null || conversionError != conversionErrorOrigin) {
        w.include = true;
        w.tested = true;
      }
    }
    return wrapJsonOBJ.toJsonObjOrArrayOrValue();
  }

  String? _getConversionErrorMessage(_Wrap wrapJsonOBJ) {
    try {
      dynamic jsonOBJ = wrapJsonOBJ.toJsonObjOrArrayOrValue();
      converter(jsonOBJ);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  _Wrap? __find(_Wrap wrap, String conversionError) {
    if (wrap is _WrapList) {
      _WrapList wrapList = wrap;
      for (_Wrap childWrap in wrapList.list) {
        if (!childWrap.tested && childWrap.include) {
          return childWrap;
        }
      }
      for (_Wrap childWrap in wrapList.list) {
        if (childWrap.tested && childWrap.include) {
          _Wrap? w = __find(childWrap, conversionError);
          if (w != null) {
            return w;
          }
        }
      }
    } else if (wrap is _WrapMap) {
      _WrapMap wrapMap = wrap;
      for (_Wrap childWrap in wrapMap.map.values) {
        _Wrap? w = __find(childWrap, conversionError);
        if (w != null) {
          return w;
        }
      }
    } else {
      return null;
    }
  }
}
