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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const double iconSize = 16;

    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: IconLabelSelectableText(
              icon: Icon(
                Icons.api_rounded,
                size: iconSize,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
              label: '${info.requestLogData.method}: ',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 13,
              ),
              text: info.requestLogData.uri.path,
              textStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.9),
                fontFamily: 'Courier',
                fontSize: 13,
              ),
            ),
          ),
          SimpleSmallIconButton(
            iconData: Icons.copy_rounded,
            iconSize: 14,
            iconColor: colorScheme.onSurfaceVariant,
            onPressed: () {
              String text =
                  "${info.requestLogData.baseUrl}${info.requestLogData.uri.path}";
              Clipboard.setData(ClipboardData(text: text));
              _closeAllSnackBars(context);
              _showSnackBar(context, "URL Copied");
            },
          ),
        ],
      ),
    );
  }
}
