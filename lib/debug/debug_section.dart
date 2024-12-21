part of '../rest_debug_screen.dart';

class RestDebugSection extends StatefulWidget {
  const RestDebugSection({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RestDebugSectionState();
  }
}

class _RestDebugSectionState extends State<RestDebugSection> {
  RequestLogInfo? info;

  @override
  void initState() {
    super.initState();
    info = restLogger.getSelectedRequestLogInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DioRequestListSection(
          onSelectRequestId: _onSelectRequestId,
        ),
        if (info != null) const Divider(height: 6),
        if (info != null)
          _DioPathSection(
            info: info!,
          ),
        const Divider(height: 6),
        //
        Expanded(
          child: _buildMain(context),
        ),
      ],
    );
  }

  Widget _buildMain(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if (info != null) //
              _DioRequestInfoSection(info: info!),
            if (info != null) const SizedBox(height: 10),
            if (info != null) //
              _DioResponseSection(info: info!),
            //
            if (info != null) const SizedBox(height: 10),
            if (info != null) //
              _JsonConvertSection(info: info!),
          ],
        ),
      ),
    );
  }

  void _onSelectRequestId(int requestId) {
    restLogger.setSelectedDioRequestID(requestId);
    info = restLogger.getSelectedRequestLogInfo();
    setState(() {});
  }
}
