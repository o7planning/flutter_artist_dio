part of '../../../flutter_artist_dio.dart';

class _PathSection extends StatelessWidget {
  final String? label;
  final ApiLogData info;
  final Function() onFullScreenPressed;

  const _PathSection({
    this.label,
    required this.info,
    required this.onFullScreenPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isComparison = label == "COMPARISON";
    final labelColor =
        isComparison ? colorScheme.secondary : colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: labelColor.withValues(alpha: 0.05),
        border: Border(
            bottom:
                BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          // Hiển thị Nhãn và ID (Ví dụ: [PRIMARY #21])
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isComparison) ...[
                  const Icon(Icons.flag_rounded, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                ],
                Text(
                  "${label ?? 'LOG'} #${info.apiLogId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: IconLabelSelectableText(
              icon: Icon(Icons.api_rounded, size: 16, color: labelColor),
              label: '${info.requestLogData.method}: ',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: labelColor, fontSize: 12),
              text: info.requestLogData.uri.path,
              textStyle: TextStyle(
                color: colorScheme.onSurface,
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
          ),
          // Nút Copy
          SimpleSmallIconButton(
            iconData: Icons.copy_all_rounded,
            iconSize: 14,
            onPressed: () {
              Clipboard.setData(
                  ClipboardData(text: info.requestLogData.uri.toString()));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("URL Copied"), duration: Duration(seconds: 1)));
            },
          ),
        ],
      ),
    );
  }
}
