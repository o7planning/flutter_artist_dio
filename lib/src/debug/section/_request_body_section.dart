part of '../../../flutter_artist_dio.dart';

class _RequestBodySection extends StatelessWidget {
  final ApiLogData apiLogData;

  const _RequestBodySection({
    super.key,
    required this.apiLogData,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> mapData = apiLogData.requestLogData.mapData;
    dynamic rawBody = apiLogData.requestLogData.data;

    return _CustomAppContainer.transparent(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: _buildBodyContent(context, mapData, rawBody),
    );
  }

  Widget _buildBodyContent(
      BuildContext context, Map<String, dynamic> mapData, dynamic rawData) {
    if (mapData.isNotEmpty) {
      return _JsonTreeView(
        jsonObjOrArray: mapData,
        isTree: false,
      );
    }
    if (rawData != null) {
      String displayBody = "";
      if (rawData is String) {
        displayBody = rawData;
      } else {
        displayBody = rawData.toString();
      }

      if (displayBody.trim().isNotEmpty) {
        return SingleChildScrollView(
          child: _TextView(text: displayBody),
        );
      }
    }

    return _buildEmptyState(
        context, "Request Body is Empty", Icons.data_object_outlined);
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message.toUpperCase(),
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
