part of '../../../rest_debug_screen.dart';

class _DioRequestListSection extends StatelessWidget {
  final void Function(int requestId) onSelectRequestId;

  final double _fontSize = 13;
  final double _iconSize = 16;
  final double _verticalPadding = 10;
  final double _horizontalPadding = 6;

  const _DioRequestListSection({
    required this.onSelectRequestId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<ApiLogData> infos = apiLogger.getApiLogDatas();

    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      width: double.infinity,
      child: infos.isEmpty
          ? Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.api_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "No API Logs",
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : BreadCrumb(
              divider: const SizedBox(width: 8),
              overflow: ScrollableOverflow(
                keepLastDivider: false,
                reverse: false,
                direction: Axis.horizontal,
              ),
              items: infos
                  .map(
                    (e) => BreadCrumbItem(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      content: _buildItemWidget(context, e),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  String _toTooltip(ApiError apiError) {
    if (apiError.errorType != null) {
      return apiError.errorType!.description;
    }
    return "";
  }

  Widget _buildItemWidget(BuildContext context, ApiLogData info) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ErrorLogData? dioErrorData = info.errorLogData;
    ApiError? conversationError = info.conversationError;
    final ApiErrorType? apiErrorType =
        dioErrorData?.apiErrorType ?? conversationError?.errorType;

    final bool isSelected = info.apiLogId == apiLogger.selectedDioRequestID;

    final Color statusColor = apiErrorType != null
        ? colorScheme.error
        : (isSelected
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.7));

    return Tooltip(
      message: info.conversationError == null
          ? "Request ${info.apiLogId}"
          : _toTooltip(info.conversationError!),
      child: InkWell(
        onTap: () => onSelectRequestId(info.apiLogId),
        borderRadius: BorderRadius.circular(20), // Bo tròn dạng viên thuốc
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            // CHIÊU 2: Nền mờ ảo, hít màu primary khi chọn
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.15)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : theme.dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                apiErrorType != null
                    ? _getErrorIconData(apiErrorType)
                    : Icons.check_circle_outline,
                color: statusColor,
                size: _iconSize,
              ),
              const SizedBox(width: 6),
              Text(
                "${info.apiLogId}",
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
