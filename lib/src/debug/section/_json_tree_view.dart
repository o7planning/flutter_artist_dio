part of '../../../flutter_artist_dio.dart';

class _JsonTreeView extends StatelessWidget {
  final Object jsonObjOrArray;
  final bool isTree;

  const _JsonTreeView({
    required this.jsonObjOrArray,
    required this.isTree,
  });

  ///  INTELLIGENT FLAT DISPATCHER
  /// Formats sequential collections, large byte vectors, and specialized tokens
  /// into a single-line readable representation for localized request telemetry.
  String _getReadableValue(dynamic valueData) {
    if (valueData == null) return 'null';

    // Check if the data is a customized string wrapper formatted inside RequestLogData
    final String strCheck = valueData.toString();
    if (strCheck.startsWith('<') && strCheck.endsWith('>')) {
      return strCheck; // Directly returns wrappers like <MultipartFile> or <Uint8List length=...>
    }

    // Process generic List containers eagerly into flattened single-line strings
    if (valueData is List) {
      if (valueData.length > 100) {
        final firstElements = valueData.take(3).join(', ');
        return '[$firstElements, ..., ${valueData.last}] (length: ${valueData.length})';
      }
      return '[${valueData.join(', ')}]';
    }

    if (valueData is Map) {
      return '{${valueData.entries.map((e) => '${e.key}: ${e.value}').join(', ')}}';
    }

    return valueData.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Builds tree nodes exactly using your native algorithm architecture
    TreeNode rootTreeNode = isTree
        ? _getRootWithChildren(jsonObjOrArray)
        : _getFlatRootWithChildren(jsonObjOrArray);

    return TreeView.simple(
      tree: rootTreeNode,
      showRootNode: false,
      expansionBehavior: ExpansionBehavior.snapToTop,
      expansionIndicatorBuilder: (context, node) {
        final theme = Theme.of(context);
        return PlusMinusIndicator(
          tree: node,
          color: theme.hintColor.withValues(alpha: 0.7),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          curve: Curves.linear,
        );
      },
      indentation: Indentation(
        width: isTree ? Indentation.DEF_INDENT_WIDTH : 0,
        style: IndentStyle.roundJoint,
        thickness: 1,
      ),
      onTreeReady: (TreeViewController<dynamic, TreeNode<dynamic>> controller) {
        // controller.expandAllChildren(rootTreeNode);
      },
      builder: (context, node) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        _NodeDataWrap nodeDataWrap = node.data;
        String title = nodeDataWrap.title;
        String? value;

        dynamic nodeData = nodeDataWrap.data;
        String iconPath =
            "statics-rs/green.gif"; // Safe initial state asset allocation
        Widget? neutralIcon;

        // =====================================================================
        //  ARCHITECTURAL SCOPE SEPARATION FOR RENDERING THEME-SAFE ICONS
        // =====================================================================
        if (!isTree) {
          //  SCENARIO A: FLAT REQUEST VIEW MODE -> Apply adaptive, neutral vector assets
          value = _getReadableValue(nodeData);

          final IconData neutralIconData = (nodeData is Map || nodeData is List)
              ? Icons.layers // Signifies a compound parent data row entry
              : Icons
                  .radio_button_checked; // Signifies a plain terminal primitive entry

          neutralIcon = Icon(
            neutralIconData,
            size: 14,
            // Strictly uses system ThemeTokens dynamically to prevent layout breaks on contrasting styles
            color: theme.brightness == Brightness.dark
                ? colorScheme.onSurfaceVariant
                : colorScheme.primary,
          );
        } else {
          //  SCENARIO B: TREE RESPONSE VIEW MODE -> Preserves original .gif asset allocations verbatim
          if (nodeData is Map) {
            iconPath = "statics-rs/object.gif";
          } else if (nodeData is List) {
            iconPath = "statics-rs/array.gif";
          } else {
            iconPath = nodeData is num
                ? "statics-rs/blue.gif"
                : nodeData is bool
                    ? "statics-rs/red.gif"
                    : "statics-rs/green.gif";
            value = nodeData.toString();
          }
        }

        // Color computation loop remaining untouched to preserve your original layout balance
        Color semanticIconColor;
        if (nodeData == null) {
          semanticIconColor = Colors.redAccent;
        } else if (nodeData is Map) {
          semanticIconColor = colorScheme.primary;
        } else if (nodeData is List) {
          semanticIconColor = colorScheme.secondary;
        } else if (nodeData is String) {
          semanticIconColor = Colors.blueAccent;
        } else {
          semanticIconColor = Colors.greenAccent;
        }

        // Mount the dynamic icon wrapper based on current tree context constraints
        Widget styledIcon = neutralIcon ??
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                theme.brightness == Brightness.dark
                    ? Color.lerp(semanticIconColor, Colors.white, 0.2)!
                    : semanticIconColor,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconPath,
                width: 16,
                height: 16,
                package: 'flutter_artist_dio',
              ),
            );

        return ListTile(
          dense: true,
          visualDensity: const VisualDensity(
            horizontal: -3,
            vertical: -3,
          ),
          horizontalTitleGap: !isTree ? 6 : 0,
          // Injected spacing gap for the material icons track
          minVerticalPadding: 2,
          minLeadingWidth: 20,
          minTileHeight: 20,
          contentPadding: EdgeInsets.only(
            left: isTree ? 25 : 0,
            right: 10,
          ),
          title: HoverWidget(
            hoverChild: _buildTextNode(
              context: context,
              icon: styledIcon,
              label: title,
              text: value,
              isHovering: true,
            ),
            onHover: (_) {},
            child: _buildTextNode(
              context: context,
              icon: styledIcon,
              label: title,
              text: value,
              isHovering: false,
            ),
          ),
        );
      },
    );
  }

  TreeNode _getRootWithChildren(Object rootData) {
    TreeNode treeNode = TreeNode(
      key: "Root",
      data: _NodeDataWrap(title: "JSON", data: rootData),
      parent: null,
    );
    TreeNode rootTreeNode = TreeNode.root()..add(treeNode);
    _addChildNodesCascade(currentNode: treeNode, nodeData: rootData);
    return rootTreeNode;
  }

  TreeNode _getFlatRootWithChildren(Object rootData) {
    TreeNode rootTreeNode = TreeNode.root();
    _addChildNodesCascade(currentNode: rootTreeNode, nodeData: rootData);
    return rootTreeNode;
  }

  void _addChildNodesCascade({
    required TreeNode currentNode,
    required Object nodeData,
  }) {
    if (nodeData is List) {
      //  STRUCTURAL CONTROL: Prevent deep nesting loops if running in flat list alignment mode
      if (!isTree) return;

      int i = 0;
      for (Object childNodeData in nodeData) {
        TreeNode childNode = TreeNode(
          data: _NodeDataWrap(title: "${i++}", data: childNodeData),
          parent: currentNode,
        );
        currentNode.add(childNode);
        _addChildNodesCascade(
          currentNode: childNode,
          nodeData: childNodeData,
        );
      }
    } else if (nodeData is Map) {
      for (Object key in nodeData.keys) {
        Object? childNodeData = nodeData[key];
        if (key is String) {
          TreeNode childNode = TreeNode(
            data: _NodeDataWrap(title: key, data: childNodeData),
            parent: currentNode,
          );
          currentNode.add(childNode);
          if (childNodeData != null) {
            _addChildNodesCascade(
              currentNode: childNode,
              nodeData: childNodeData,
            );
          }
        }
      }
    }
  }

  Widget _buildTextNode({
    required BuildContext context,
    required Widget icon,
    required String label,
    required String? text,
    required bool isHovering,
  }) {
    return IconLabelText(
      icon: icon,
      label: text == null || text.isEmpty ? label : "$label: ",
      text: text ?? '',
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 13,
      ),
      suffixIcon: isHovering && text != null && text.isNotEmpty
          ? SimpleSmallIconButton(
              iconData: Icons.copy,
              iconSize: 13,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                _closeAllSnackBars(context);
                _showSnackBar(
                  context,
                  "Copied",
                );
              },
            )
          : null,
    );
  }

  void _closeAllSnackBars(BuildContext ctx) =>
      ScaffoldMessenger.of(ctx).clearSnackBars();

  void _showSnackBar(BuildContext ctx, String m) =>
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(m)));
}
