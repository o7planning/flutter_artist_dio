part of '../../../flutter_artist_dio.dart';

class _MapKeyValueView extends StatelessWidget {
  final Map<String, dynamic> map;

  const _MapKeyValueView({required this.map});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var encoder = const JsonEncoder.withIndent("   ");
    var json = encoder.convert(map);

    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: SelectableText(
        json,
        style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 12,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
