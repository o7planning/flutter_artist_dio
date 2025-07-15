part of '../../../rest_debug_screen.dart';

class _DioRequestListSection extends StatelessWidget {
  final void Function(int requestId) onSelectRequestId;

  const _DioRequestListSection({
    required this.onSelectRequestId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RequestLogInfo> infos = restLogger.getRequestLogInfos();
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

  Widget _buildItemWidget(RequestLogInfo info) {
    ApiError? apiError = info.apiError;

    return Tooltip(
      message: info.apiError == null ? "" : _toTooltip(info.apiError!),
      child: ElevatedButton.icon(
        onPressed: () {
          onSelectRequestId(info.dioRequestID);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          backgroundColor: info.dioRequestID == restLogger.selectedDioRequestID
              ? Colors.blue.withAlpha(60)
              : null,
        ),
        icon: Icon(
          apiError != null ? _getErrorIconData(apiError) : Icons.check,
          color: apiError != null ? Colors.redAccent : Colors.blue,
          size: 18,
        ),
        label: Text("${info.dioRequestID}"),
      ),
    );
  }
}
