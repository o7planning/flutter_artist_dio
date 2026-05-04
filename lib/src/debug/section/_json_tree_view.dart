part of '../../../flutter_artist_dio.dart';

class _JsonTreeView extends StatelessWidget {
  final Object jsonObjOrArray;
  final bool isTree;

  const _JsonTreeView({
    super.key,
    required this.jsonObjOrArray,
    required this.isTree,
  });

  @override
  Widget build(BuildContext context) {
    TreeNode rootTreeNode = isTree
        ? _getRootWithChildren(jsonObjOrArray)
        : _getFlatRootWithChildren(jsonObjOrArray);
    //
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
      onTreeReady: (
        TreeViewController<dynamic, TreeNode<dynamic>> controller,
      ) {
        // _treeViewController = controller;
        // controller.expandAllChildren(rootTreeNode);
      },
      builder: (context, node) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        _NodeDataWrap nodeDataWrap = node.data;
        String title = nodeDataWrap.title;
        String? value;

        dynamic nodeData = nodeDataWrap.data;
        String iconPath;
        Color iconColor;

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

        Widget styledIcon = ColorFiltered(
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
          horizontalTitleGap: 0,
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
    //
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
      int i = 0;
      for (Object childNodeData in nodeData) {
        TreeNode childNode = TreeNode(
          data: _NodeDataWrap(title: "${i++}", data: childNodeData),
          parent: currentNode,
        );
        currentNode.add(childNode);
        //
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
          //
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
      label: "$label: ",
      text: text ?? '',
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 13,
      ),
      suffixIcon: isHovering && text != null //
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
}
