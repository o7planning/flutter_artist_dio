part of '../../../rest_debug_screen.dart';

class _RequestHeadersSection extends StatelessWidget {
  final ApiLogData apiLogData;
  final bool showAuthorization;

  const _RequestHeadersSection({
    super.key,
    required this.apiLogData,
    required this.showAuthorization,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _CustomAppContainer.transparent(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              context,
              Icons.language,
              'Base URL: ',
              apiLogData.requestLogData.baseUrl,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              context,
              Icons.link,
              'Path: ',
              apiLogData.requestLogData.uri.path,
              textColor: colorScheme.primary,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              context,
              Icons.tonality_outlined,
              'Method: ',
              apiLogData.requestLogData.method,
              textColor: colorScheme.tertiary,
            ),
            if (apiLogData.authorization != null) ...[
              const SizedBox(height: 10),
              _buildAuthorizationRow(context, colorScheme),
            ],
            if (apiLogData.requestLogData.queryParameters.isNotEmpty) ...[
              const SizedBox(height: 15),
              _buildSectionHeader(
                  context, Icons.manage_search, 'Query Parameters'),
              const SizedBox(height: 8),
              _MapKeyValueView(map: apiLogData.requestLogData.queryParameters),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Divider(color: colorScheme.primary.withValues(alpha: 0.1))),
      ],
    );
  }

  Widget _buildAuthorizationRow(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.enhanced_encryption_outlined,
                  size: 14, color: colorScheme.secondary),
              const SizedBox(width: 8),
              Text(
                "Authorization",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            apiLogData.authorization ?? '',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String text,
      {Color? textColor}) {
    return IconLabelSelectableText(
      icon: Icon(icon,
          size: defaultIconSize,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
      label: label,
      text: text,
      labelStyle: defaultLabelStyle(context),
      textStyle: defaultTextStyle(context).copyWith(
          color: textColor,
          fontWeight: textColor != null ? FontWeight.bold : null),
    );
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return "${text.substring(0, maxLength)}...";
  }
}
