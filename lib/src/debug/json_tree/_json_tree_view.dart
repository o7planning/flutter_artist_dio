part of '../../../rest_debug_screen.dart';

class _JsonTreeView extends StatelessWidget {
  final Object rootData;

  const _JsonTreeView({
    super.key,
    required this.rootData,
  });

  TreeNode _getRootWithChildren() {
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
        Object childNodeData = nodeData[key];
        if (key is String) {
          TreeNode childNode = TreeNode(
            data: _NodeDataWrap(title: key, data: childNodeData),
            parent: currentNode,
          );
          currentNode.add(childNode);
          //
          _addChildNodesCascade(
            currentNode: childNode,
            nodeData: childNodeData,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TreeNode rootTreeNode = _getRootWithChildren();
    //
    return _CustomAppContainer(
      width: double.infinity,
      child: TreeView.simple(
        tree: rootTreeNode,
        showRootNode: false,
        expansionBehavior: ExpansionBehavior.none,
        expansionIndicatorBuilder: (context, node) {
          // PlusMinusIndicator
          return ChevronIndicator.upDown(
            tree: node,
            color: Colors.grey[700],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
            icon: Icons.keyboard_arrow_down_outlined,
          );
        },
        indentation: const Indentation(
          style: IndentStyle.squareJoint,
          thickness: 1,
          width: 10,
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
            title += " : $nodeData";
          }
          //
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(
              horizontal: -3,
              vertical: -3,
            ),
            contentPadding: const EdgeInsets.only(left: 25),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
