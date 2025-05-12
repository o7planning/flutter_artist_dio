part of '../../../rest_debug_screen.dart';

class _MapKeyValueView extends StatelessWidget {
  final Map<String, dynamic> map;

  const _MapKeyValueView({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    var encoder = const JsonEncoder.withIndent("   ");
    var json = encoder.convert(map);

    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      child: SelectableText(json),
    );
  }
}
