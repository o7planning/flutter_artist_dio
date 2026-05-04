part of '../../../flutter_artist_dio.dart';

class _RequestListSection extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onClear;
  final void Function(int requestId) onSelectRequestId;

  const _RequestListSection({
    required this.onSelectRequestId,
    required this.onRefresh,
    required this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<ApiLogData> infos = apiLogger.getApiLogDatas();

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
            bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.2), width: 1)),
      ),
      child: Row(
        children: [
          _buildFilterButton(context, theme),
          const VerticalDivider(width: 1, indent: 12, endIndent: 12),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: infos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final info = infos[index];
                return _LogItemChip(
                  info: info,
                  isSelected: info.apiLogId == apiLogger.selectedDioRequestID,
                  onRefresh: onRefresh,
                );
              },
            ),
          ),
          const VerticalDivider(width: 1, indent: 12, endIndent: 12),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SimpleSmallIconButton(
          iconData: apiLogger.splitMode
              ? Icons.vertical_split
              : Icons.horizontal_rule,
          iconColor: apiLogger.splitMode
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          onPressed: () {
            apiLogger.toggleSplitMode();
            onRefresh();
          },
          tooltip: "Toggle Split Mode",
        ),
        Opacity(
          opacity: apiLogger.splitMode ? 1.0 : 0.3,
          child: SimpleSmallIconButton(
            iconData: apiLogger.syncMode ? Icons.link : Icons.link_off,
            iconColor: (apiLogger.splitMode && apiLogger.syncMode)
                ? colorScheme.secondary
                : colorScheme.onSurfaceVariant,
            onPressed: apiLogger.splitMode
                ? () {
                    apiLogger.toggleSyncMode();
                    onRefresh();
                  }
                : null,
            tooltip: "Sync Logs",
          ),
        ),
        const VerticalDivider(width: 1, indent: 15, endIndent: 15),
        SimpleSmallIconButton(
          iconData: Icons.delete_sweep_outlined,
          iconColor: colorScheme.error,
          onPressed: onClear,
        ),
      ],
    );
  }

  Widget _buildFilterButton(BuildContext context, ThemeData theme) {
    final availableMethods = apiLogger.getAvailableMethods();
    final colorScheme = theme.colorScheme;

    return PopupMenuButton(
      icon: Icon(
        Icons.filter_alt_outlined,
        color:
            (apiLogger.selectedMethods.isNotEmpty || apiLogger.showOnlyErrors)
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
      ),
      constraints: const BoxConstraints(minWidth: 200),
      onSelected: (value) {
        if (value == "ERRORS") {
          apiLogger.showOnlyErrors = !apiLogger.showOnlyErrors;
        } else if (value is String) {
          if (apiLogger.selectedMethods.contains(value)) {
            apiLogger.selectedMethods.remove(value);
          } else {
            apiLogger.selectedMethods.add(value);
          }
        }
        onRefresh();
      },
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            enabled: false,
            child: Row(
              children: [
                Icon(Icons.tune, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "FILTER METHODS",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          ...availableMethods.map(
            (m) => CustomCheckedPopupMenuItem(
              value: m,
              checked: apiLogger.selectedMethods.contains(m),
              child: Text(
                m,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: apiLogger.selectedMethods.contains(m)
                      ? colorScheme.primary
                      : null,
                ),
              ),
            ),
          ),
          const PopupMenuDivider(),
          CustomCheckedPopupMenuItem(
            value: "ERRORS",
            checked: apiLogger.showOnlyErrors,
            child: Text(
              "Errors Only",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ];
      },
    );
  }
}
