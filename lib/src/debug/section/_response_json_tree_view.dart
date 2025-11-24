part of '../../../rest_debug_screen.dart';

class _ResponseJsonTreeView extends StatelessWidget {
  final ApiLogData apiLogData;

  const _ResponseJsonTreeView({
    super.key,
    required this.apiLogData,
  });

  @override
  Widget build(BuildContext context) {
    bool hasNoResponseData = apiLogData.hasNoResponseData();
    // JSON Object or Array:
    Object? jsonObjOrArray = apiLogData.getRealJsonObjOrArray();
    //
    if (!hasNoResponseData) {
      // Not JSON:
      if (jsonObjOrArray == null) {
        return SizedBox(
          width: double.maxFinite,
          child: Text(
            apiLogData.getResponseText() ?? "",
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
