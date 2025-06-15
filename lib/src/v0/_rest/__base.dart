part of '../flutter_artist_dio.dart';

int _dioRequestSEQ = 1;
const String _keyDioRequestID = "__dioRequestID__";

int _getRequestIdFromHeaders({required Map<String, dynamic> headers}) {
  return headers[_keyDioRequestID]!;
}

int _addRequestIdToHeaders({required Map<String, dynamic> headers}) {
  _dioRequestSEQ++;
  int newRequestID = _dioRequestSEQ;
  headers[_keyDioRequestID] = newRequestID;
  return newRequestID;
}
