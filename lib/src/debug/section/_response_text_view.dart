part of '../../../rest_debug_screen.dart';

class _ResponseTextView extends StatefulWidget {
  final ApiLogData apiLogData;

  const _ResponseTextView({
    required super.key,
    required this.apiLogData,
  });

  @override
  State<StatefulWidget> createState() {
    return _ResponseTextViewState();
  }
}

class _ResponseTextViewState extends State<_ResponseTextView> {
  @override
  Widget build(BuildContext context) {
    bool hasNoResponseData = widget.apiLogData.hasNoResponseData();
    // JSON Object or Array:
    Object? jsonObj = widget.apiLogData.getRealJsonObjOrArray();
    //
    if (!hasNoResponseData) {
      // Not JSON:
      if (jsonObj == null) {
        return SizedBox(
          width: double.maxFinite,
          child: Text(
            widget.apiLogData.getResponseText() ?? "",
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

    return _TextView(text: widget.apiLogData.getResponseText() ?? "");
  }
}
