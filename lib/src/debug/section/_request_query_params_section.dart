part of '../../../flutter_artist_dio.dart';

class _RequestQueryParamsSection extends StatelessWidget {
  final ApiLogData apiLogData;

  const _RequestQueryParamsSection({
    required this.apiLogData,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> queryParameters =
        apiLogData.requestLogData.queryParameters;

    return _CustomAppContainer.transparent(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: queryParameters.isEmpty
          ? _buildEmptyState(
              context, "No Query Parameters", Icons.manage_search_outlined)
          : _JsonTreeView(
              jsonObjOrArray: queryParameters,
              isTree: false,
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
