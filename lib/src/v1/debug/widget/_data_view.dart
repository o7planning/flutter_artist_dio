part of '../../../../rest_debug_screen.dart';

class _DataView extends StatefulWidget {
  final dynamic data;

  const _DataView({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    return _DataViewState();
  }
}

class _DataViewState extends State<_DataView> {
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
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
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
            top: 10,
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
