part of '../../../rest_debug_screen.dart';

class _JsonTreeView extends StatelessWidget {
  final Object jsonObjOrArray;

  const _JsonTreeView({
    super.key,
    required this.jsonObjOrArray,
  });

  @override
  Widget build(BuildContext context) {
    TreeNode rootTreeNode = _getRootWithChildren(jsonObjOrArray);
    //
    return TreeView.simple(
      tree: rootTreeNode,
      showRootNode: false,
      expansionBehavior: ExpansionBehavior.snapToTop,
      expansionIndicatorBuilder: (context, node) {
        // PlusMinusIndicator
        // ChevronIndicator.upDown
        return PlusMinusIndicator(
          tree: node,
          color: Colors.grey[600],
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          // icon: Icons.keyboard_arrow_down_outlined,
          curve: Curves.linear,
        );
      },
      indentation: const Indentation(
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
        _NodeDataWrap nodeDataWrap = node.data;
        String title = nodeDataWrap.title;
        String? value;

        dynamic nodeData = nodeDataWrap.data;
        Widget icon;
        if (nodeData is Map) {
          icon = Image.asset(
            "statics-rs/object.gif",
            package: 'flutter_artist_dio',
          );
        } else if (nodeData is List) {
          icon = Image.asset(
            "statics-rs/array.gif",
            package: 'flutter_artist_dio',
          );
        } else {
          if (nodeData == null) {
            icon = Image.asset(
              "statics-rs/red.gif",
              package: 'flutter_artist_dio',
            );
          } else if (nodeData is String) {
            icon = Image.asset(
              "statics-rs/blue.gif",
              package: 'flutter_artist_dio',
            );
          } else {
            icon = Image.asset(
              "statics-rs/green.gif",
              package: 'flutter_artist_dio',
            );
          }
          value =  nodeData.toString();
        }
        //
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
          contentPadding: const EdgeInsets.only(left: 25),
          title: HoverWidget(
            hoverChild: _buildTextNode(
              context: context,
              icon: icon,
              label: title,
              text: value,
              isHovering: true,
            ),
            onHover: (_) {},
            child: _buildTextNode(
              context: context,
              icon: icon,
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
