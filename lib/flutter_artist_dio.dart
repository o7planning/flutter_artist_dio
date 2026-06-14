import 'dart:collection';
import 'dart:convert';

import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:animated_tree_view/tree_view/tree_view.dart';
import 'package:animated_tree_view/tree_view/widgets/expansion_indicator.dart';
import 'package:animated_tree_view/tree_view/widgets/indent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_artist_commons_ui/flutter_artist_commons_ui.dart';
import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:flutter_artist_dio/src/core/_model/detailed_data.dart';
import 'package:flutter_artist_dio/src/core/_utils/dio_error_utils.dart';
import 'package:flutter_artist_dio/src/utils/_tab_theme_utils.dart';
import 'package:hovering/hovering.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'src/debug/_constants.dart';
import 'src/debug/widget/_custom_checked_popup_menu_item.dart';

part 'src/core/_error_detector/__json_conversion_error_detector.dart';

part 'src/core/_error_detector/__wrap_map.dart';

part 'src/core/_error_handler/__handle_dio_exception.dart';

part 'src/core/_error_handler/__handle_dio_response.dart';

part 'src/core/_error_handler/__handle_exception.dart';

part 'src/core/_model/api_log_data.dart';

part 'src/core/_model/api_log_helper.dart';

part 'src/core/_model/api_logger.dart';

part 'src/core/_model/error_log_data.dart';

part 'src/core/_model/request_log_data.dart';

part 'src/core/_model/response_log_data.dart';

part 'src/core/_rest_binary/_download.dart';

//
part 'src/core/_rest_binary/_get_binary.dart';

part 'src/core/_rest_json/_delete.dart';

part 'src/core/_rest_json/_get.dart';

part 'src/core/_rest_json/_options.dart';

part 'src/core/_rest_json/_post.dart';

part 'src/core/_rest_json/_put.dart';

part 'src/debug/_utils.dart';

part 'src/debug/debug_network_inspector.dart';

part 'src/debug/dialog/_debug_network_inspector_dialog.dart';

part 'src/debug/dialog/_json_tree_view_dialog.dart';

part 'src/debug/json_tree/_node_data.dart';

part 'src/debug/section/_json_tree_view.dart';

part 'src/debug/section/_path_section.dart';

part 'src/debug/section/_request_body_section.dart';

part 'src/debug/section/_request_headers_section.dart';

part 'src/debug/section/_request_list_section.dart';

part 'src/debug/section/_request_query_params_section.dart';

part 'src/debug/section/_response_body_section.dart';

part 'src/debug/section/_response_headers_section.dart';

part 'src/debug/section/_response_json_tree_view.dart';

part 'src/debug/section/_response_text_view.dart';

part 'src/debug/section/_text_view.dart';

part 'src/debug/widget/_custom_app_container.dart';

part 'src/debug/widget/_log_item_chip.dart';

part 'src/debug/widget/_map_key_value_view.dart';

part 'src/fa_dio.dart';

part 'src/flutter_artist_dio_logger_interceptor.dart';

part 'src/rest_debug_screen.dart';
