import 'dart:convert';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:hovering/hovering.dart';

import 'flutter_artist_dio.dart';

part 'src/debug/_utils.dart';
part 'src/debug/dialog/_json_tree_view_dialog.dart';
part 'src/debug/dialog/_rest_debug_dialog.dart';
part 'src/debug/json_tree/_node_data.dart';
part 'src/debug/rest_debug_view.dart';
part 'src/debug/section/_dio_path_section.dart';
part 'src/debug/section/_dio_request_info_section.dart';
part 'src/debug/section/_dio_request_list_section.dart';
part 'src/debug/section/_dio_response_section.dart';
part 'src/debug/section/_json_tree_view.dart';
part 'src/debug/section/_response_json_tree_view.dart';
part 'src/debug/section/_response_text_view.dart';
part 'src/debug/section/_response_view.dart';
part 'src/debug/section/_text_view.dart';
part 'src/debug/widget/_custom_app_container.dart';
part 'src/debug/widget/_map_key_value_view.dart';

class RestDebugScreen extends StatelessWidget {
  static const String routeName = "/restDebugScreen";

  const RestDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rest Debug"),
      ),
      body: const RestDebugView(
        showJson: true,
        showInScrollView: false,
        showToken: false,
      ),
    );
  }
}
