part of '../../../rest_debug_screen.dart';

class _TextView extends StatefulWidget {
  final String text;

  const _TextView({
    super.key,
    required this.text,
  });

  @override
  State<StatefulWidget> createState() {
    return _TextViewState();
  }
}

class _TextViewState extends State<_TextView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
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
