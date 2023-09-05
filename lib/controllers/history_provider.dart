import 'dart:developer';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/storage_functions.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryProvider with ChangeNotifier {
  final List<MapEntry<String, MapEntry<APIRequest, APIResponse>>> _requests =
      [];

  Future<void> setRequests() async {
    _requests.clear();
    try {
      final box = Hive.box(AppConstants.historyBox);
      box.toMap().entries.forEach((element) {
        final data = element.value;

        Map<dynamic, dynamic> key = data.entries.first.key; // request
        Map<dynamic, dynamic> value = data.entries.first.value; //response
        APIRequest request = APIRequest.fromJson(key.cast());
        APIResponse response = APIResponse.fromJson(value.cast());
        _requests
            .add(MapEntry(element.key.toString(), MapEntry(request, response)));
      });
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log("Get $e");
    }
  }

  Future<void> delete({required String key}) async {
    try {
      final box = Hive.box(AppConstants.historyBox);
      await deleteFromStorage(
          request:
              _requests.firstWhere((element) => element.key == key).value.key);
      _requests.removeWhere((element) => element.key == key);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) log("Delete $e");
    }
  }

  List<MapEntry<String, MapEntry<APIRequest, APIResponse>>> get getHistory =>
      _requests;
}
