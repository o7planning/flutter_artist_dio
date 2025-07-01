part of '../../../rest_debug_screen.dart';

class _ResponseTextView extends StatefulWidget {
  final bool hasNoResponseData;
  final String? text;

  const _ResponseTextView({
    super.key,
    required this.hasNoResponseData,
    required this.text,
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
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasNoResponseData) {
      return SizedBox(
        height: 100,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.hasNoResponseData ? "No Response" : "Not JSON"),
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
