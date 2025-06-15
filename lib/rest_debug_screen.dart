import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import 'src/v0/_utils_/json_utils.dart';
import 'src/v0/flutter_artist_dio.dart';

part 'src/v0/_dialog/_rest_debug_dialog.dart';
part 'src/v0/debug/_utils.dart';
part 'src/v0/debug/debug_section.dart';
part 'src/v0/debug/section/_dio_path_section.dart';
part 'src/v0/debug/section/_dio_request_info_section.dart';
part 'src/v0/debug/section/_dio_request_list_section.dart';
part 'src/v0/debug/section/_dio_response_section.dart';
part 'src/v0/debug/widget/_custom_app_container.dart';
part 'src/v0/debug/widget/_data_view.dart';
part 'src/v0/debug/widget/_map_key_value_view.dart';

class RestDebugScreen extends StatelessWidget {
  static const String routeName = "/restDebugScreen";

  const RestDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RequestLogInfo? info = restLogger.getSelectedRequestLogInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rest Debug"),
      ),
      body: const RestDebugSection(
        showJson: true,
        showInScrollView: false,
        showToken: false,
      ),
    );
  }
}
