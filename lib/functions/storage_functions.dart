import 'dart:convert';
import 'dart:developer';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> saveToStorage(
    {required APIRequest request, required APIResponse response}) async {
  try {
    final box = Hive.box(AppConstants.historyBox);
    if (box.containsKey(request.toJson().toString().hashCode) == false) {
      final data = {request.toJson(): response.toJson()};
      await box.put(
        request.toJson().toString().hashCode,
        data,
      );
    }
  } catch (e) {
    if (kDebugMode) log("Save $e");
  }
}

Future<void> deleteFromStorage({required APIRequest request}) async {
  try {
    final box = Hive.box(AppConstants.historyBox);
    int key = request.toJson().toString().hashCode;
    if (box.containsKey(key) == true) {
      await box.delete(key);
    }
  } catch (e) {
    if (kDebugMode) log("Delete $e");
  }
}
