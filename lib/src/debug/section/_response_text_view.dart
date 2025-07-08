part of '../../../rest_debug_screen.dart';

class _ResponseTextView extends StatefulWidget {
  final RequestLogInfo requestLogInfo;

  const _ResponseTextView({
    super.key,
    required this.requestLogInfo,
  });

  @override
  State<StatefulWidget> createState() {
    return _ResponseTextViewState();
  }
}

class _ResponseTextViewState extends State<_ResponseTextView> {
  @override
  Widget build(BuildContext context) {
    bool hasNoResponseData = widget.requestLogInfo.hasNoResponseData();
    // JSON Object or Array:
    Object? jsonObj = widget.requestLogInfo.getResponseJsonObjOrArray();
    //
    if (!hasNoResponseData) {
      // Not JSON:
      if (jsonObj == null) {
        return SizedBox(
          width: double.maxFinite,
          child: Text(
            widget.requestLogInfo.responseData.toString(),
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

    return _TextView(text: widget.requestLogInfo.getResponseText() ?? "");
  }
}
