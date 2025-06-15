part of '../../rest_debug_screen.dart';

class _DioPathSection extends StatelessWidget {
  final RequestLogInfo info;

  const _DioPathSection({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: IconLabelText(
              icon: const Icon(
                Icons.tonality_outlined,
                size: iconSize,
              ),
              label: '${info.requestMethod}: ',
              text: info.requestPath,
              textStyle: const TextStyle(color: Colors.indigo),
            ),
          ),
          SimpleSmallIconButton(
            iconData: Icons.copy,
            onPressed: () {
              String text = "${info.baseUrl}${info.requestPath}";
              Clipboard.setData(ClipboardData(text: text));
              _closeAllSnackBars(context);
              _showSnackBar(
                context,
                "Copied",
              );
            },
          ),
        ],
      ),
    );
  }
}
