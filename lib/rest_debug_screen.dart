import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';

import '_utils_/json_utils.dart';
import 'flutter_artist_dio.dart';

part '_dialog/_rest_debug_dialog.dart';
part 'debug/_utils.dart';
part 'debug/debug_section.dart';
part 'debug/section/_dio_path_section.dart';
part 'debug/section/_dio_request_info_section.dart';
part 'debug/section/_dio_request_list_section.dart';
part 'debug/section/_dio_response_section.dart';
part 'debug/widget/_custom_app_container.dart';
part 'debug/widget/_data_view.dart';
part 'debug/widget/_icon_label_text.dart';
part 'debug/widget/_map_key_value_view.dart';
part 'debug/widget/_simple_small_icon_button.dart';

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
