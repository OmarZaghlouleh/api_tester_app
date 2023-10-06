import 'dart:convert';

import 'package:api_tester_app/extensions/map_print_extension.dart';

String tryDecode({required String value}) {
  try {
    Map result = jsonDecode(value) as Map;
    return result.print();
  } catch (e) {
    return value;
  }
}
