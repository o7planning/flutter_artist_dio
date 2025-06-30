part of '../../../rest_debug_screen.dart';

class _NodeDataWrap {
  String title;
  dynamic data;

  _NodeDataWrap({required this.title, required this.data});
}

enum _NodeType {
  map,
  array,
  others,
}
