part of '../../rest_debug_screen.dart';

class _DioRequestListSection extends StatelessWidget {
  final void Function(int requestId) onSelectRequestId;

  const _DioRequestListSection({
    required this.onSelectRequestId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<RequestLogInfo> infos = restLogger.getRequestLogInfos();
    return _CustomAppContainer.transparent(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: infos
            .map(
              (e) => _buildItemWidget(e),
            )
            .toList(),
      ),
    );
  }

  Widget _buildItemWidget(RequestLogInfo info) {
    bool isError = info.isError;

    return ElevatedButton.icon(
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
        isError ? Icons.error : Icons.check,
        color: isError ? Colors.redAccent : Colors.blue,
        size: 18,
      ),
      label: Text("${info.dioRequestID}"),
    );
  }
}
