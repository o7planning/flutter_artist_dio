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
    List<ApiLogData> infos = apiLogger.getApiLogDatas();
    //
    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: BreadCrumb(
        divider: const SizedBox(width: 5),
        overflow: ScrollableOverflow(
          keepLastDivider: false,
          reverse: false,
          direction: Axis.horizontal,
        ),
        items: infos
            .map(
              (e) => BreadCrumbItem(
                padding: EdgeInsets.all(2),
                content: _buildItemWidget(e),
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

  Widget _buildItemWidget(ApiLogData info) {
    final ErrorLogData? dioErrorData = info.errorLogData;
    ApiError? conversationError = info.conversationError;

    final ApiErrorType? apiErrorType =
        dioErrorData?.apiErrorType ?? conversationError?.errorType;

    return Tooltip(
      message: info.conversationError == null
          ? ""
          : _toTooltip(info.conversationError!),
      child: ElevatedButton.icon(
        onPressed: () {
          onSelectRequestId(info.apiLogId);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(
            vertical: _verticalPadding,
            horizontal: _horizontalPadding,
          ),
          backgroundColor: info.apiLogId == apiLogger.selectedDioRequestID
              ? Colors.blue.withAlpha(60)
              : null,
        ),
        icon: Icon(
          apiErrorType != null ? _getErrorIconData(apiErrorType) : Icons.check,
          color: apiErrorType != null ? Colors.redAccent : Colors.blue,
          size: _iconSize,
        ),
        label: Text(
          "${info.apiLogId}",
          style: TextStyle(
            fontSize: _fontSize,
          ),
        ),
      ),
    );
  }
}
