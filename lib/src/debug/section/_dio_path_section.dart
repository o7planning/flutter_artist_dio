part of '../../../rest_debug_screen.dart';

class _DioPathSection extends StatelessWidget {
  final ApiLogData info;
  final Function() onFullScreenPressed;

  const _DioPathSection({
    super.key,
    required this.info,
    required this.onFullScreenPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: IconLabelSelectableText(
              icon: const Icon(
                Icons.tonality_outlined,
                size: iconSize,
              ),
              label: '${info.requestLogData.method}: ',
              text: info.requestLogData.uri.path,
              textStyle: const TextStyle(color: Colors.indigo),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              String text =
                  "${info.requestLogData.baseUrl}${info.requestLogData.uri.path}";
              Clipboard.setData(ClipboardData(text: text));
              _closeAllSnackBars(context);
              _showSnackBar(
                context,
                "Copied",
              );
            },
            child: Icon(Icons.copy, size: 16),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
