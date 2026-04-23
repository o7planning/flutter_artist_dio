part of '../../../rest_debug_screen.dart';

class _LogItemChip extends StatelessWidget {
  final ApiLogData info;
  final bool isSelected;
  final VoidCallback onRefresh;

  const _LogItemChip({
    required this.info,
    required this.isSelected,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor =
        info.hasError ? colorScheme.error : colorScheme.primary;
    final Color inactiveColor = colorScheme.onSurfaceVariant;
    final Color currentColor = isSelected ? statusColor : inactiveColor;

    return Center(
      child: InkWell(
        onTap: () {
          apiLogger.setSelectedDioRequestID(info.apiLogId);
          onRefresh();
        },
        onLongPress: apiLogger.splitMode && !apiLogger.syncMode
            ? () {
                apiLogger.setComparisonDioRequestID(info.apiLogId);
                onRefresh();
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? currentColor.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: statusColor,
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (info.hasError)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.error_outline_rounded,
                      size: 14, color: currentColor),
                ),
              Text(
                "${info.apiLogId}",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: currentColor,
                ),
              ),
              const SizedBox(width: 6),
              // Method Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: currentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  info.requestLogData.method,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: currentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
