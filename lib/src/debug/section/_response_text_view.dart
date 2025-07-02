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
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final String? text = widget.requestLogInfo.toResponseText();
    _controller = TextEditingController(text: text ?? "");
  }

  @override
  Widget build(BuildContext context) {
    ApiError? apiError = widget.requestLogInfo.apiError;
    if (apiError != null) {
      return SizedBox(
        width: double.maxFinite,
        child: Text(
          apiError.originErrorText ?? "",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }
    final bool hasNoResponseData = widget.requestLogInfo.hasNoResponseData();
    //
    if (hasNoResponseData) {
      return SizedBox(
        width: double.maxFinite,
        child: Text(
          "No Response",
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            controller: _controller,
            style: const TextStyle(fontSize: 13),
            readOnly: true,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
