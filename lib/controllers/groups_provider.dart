import 'dart:developer';

import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/functions/snackbar.dart';
import 'package:api_tester_app/functions/storage_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> _groups = [];

  Future<void> fetchGroups({required BuildContext context}) async {
    final result = await getGroupsFromStorage();

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      if (kDebugMode) log(r.toString());
      _groups = r;
      notifyListeners();
    });
  }

  Future<void> addGroup(
      {required BuildContext context, required String name}) async {
    final result = await addGroupToStorage(name: name, context: context);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups.add(r);
      notifyListeners();
    });
  }

  List<Group> get getGroups => _groups;
}
