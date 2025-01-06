part of '../../rest_debug_screen.dart';

class _JsonConvertSection extends StatelessWidget {
  final bool showJson;
  final RequestLogInfo info;

  const _JsonConvertSection({
    super.key,
    required this.info,
    required this.showJson,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconLabelText(
            icon: Icon(
              info.errorConvertingJson ? Icons.error : Icons.check_box_rounded,
              size: iconSize,
              color: info.errorConvertingJson ? Colors.red : Colors.blue,
            ),
            label: 'JSON to Object',
            text: '',
          ),
          const SizedBox(height: 10),
          _IconLabelText(
            icon: const Icon(
              Icons.text_snippet_outlined,
              size: iconSize,
            ),
            label: 'Message:',
            text: info.errorConvertingJsonMessage ?? '',
          ),
          if (showJson) const SizedBox(height: 10),
          if (showJson) _DataView(data: info.mainData),
        ],
      ),
    );
  }
}
