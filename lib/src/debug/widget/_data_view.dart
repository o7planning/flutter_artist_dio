part of '../../../rest_debug_screen.dart';

class _JsonDataView extends StatefulWidget {
  final dynamic data;

  const _JsonDataView({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    return _JsonDataViewState();
  }
}

class _JsonDataViewState extends State<_JsonDataView> {
  late TextEditingController _controller;
  bool expand = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    var text = toBeautifulJsonOLD(widget.data);
    _controller.text = text;
    return _CustomAppContainer(
      width: double.infinity,
      child: Stack(
        children: [
          TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            controller: _controller,
            style: const TextStyle(fontSize: 13),
            minLines: null,
            maxLines: expand ? null : 10,
            readOnly: true,
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SimpleSmallIconButton(
                  iconData: Icons.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    _closeAllSnackBars(context);
                    _showSnackBar(
                      context,
                      "Copied",
                    );
                  },
                ),
                const SizedBox(width: 5),
                SimpleSmallIconButton(
                  iconData: expand
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down,
                  onPressed: () {
                    expand = !expand;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
