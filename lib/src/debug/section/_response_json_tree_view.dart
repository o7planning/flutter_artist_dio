part of '../../../rest_debug_screen.dart';

class _ResponseJsonTreeView extends StatelessWidget {
  final RequestLogInfo requestLogInfo;

  const _ResponseJsonTreeView({
    super.key,
    required this.requestLogInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool hasNoResponseData = requestLogInfo.hasNoResponseData();
    // JSON Object or Array:
    Object? jsonObjOrArray = requestLogInfo.toResponseJson();
    //
    if (!hasNoResponseData) {
      // Not JSON:
      if (jsonObjOrArray == null) {
        return SizedBox(
          width: double.maxFinite,
          child: Text(
            requestLogInfo.responseData.toString(),
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        );
      }
    }
    // Has No Response:
    else {
      return SizedBox(
        width: double.maxFinite,
        child: Text(
          "No Response",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }
    return _JsonTreeView(jsonObjOrArray: jsonObjOrArray);
  }
}
