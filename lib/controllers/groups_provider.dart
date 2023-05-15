import 'dart:developer';

import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/extensions/update_list_element+extension.dart';
import 'package:api_tester_app/functions/snackbar.dart';
import 'package:api_tester_app/functions/storage_functions.dart';
import 'package:api_tester_app/screens/group/groups_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../classes/folder.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> _groups = [];
  Folder? _selectedFolder;
  String _selectedGroupName = "";

  void setSelectedFolder({required Folder folder, required String groupName}) {
    log(folder.requests.toString());
    _selectedGroupName = groupName;
    if (folder.hashCode == _selectedFolder.hashCode) return;
    _selectedFolder = folder;

    notifyListeners();
  }

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
    final result = await addGroupToStorage(name: name);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups.add(r);
      notifyListeners();
    });
  }

  Future<void> addFolder(
      {required Group group,
      required String folderName,
      required BuildContext context}) async {
    final result =
        await addFolderToStorage(groupName: group.name, folderName: folderName);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups.update(key: group, newValue: r);
      notifyListeners();
    });
  }

  Future<void> deleteGroup(
      {required BuildContext context, required String name}) async {
    final result = await deleteGroupFromStorage(name: name);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      if (_groups
          .firstWhere((element) => element.name == name)
          .folders
          .contains(_selectedFolder)) _selectedFolder = null;
      _groups.removeWhere((element) => element.name == name);
      notifyListeners();
    });
  }

  Future<void> addTestToFolder(
      {required String folderName,
      required String groupName,
      required APIRequest apiRequest,
      required APIResponse apiResponse,
      required BuildContext context}) async {
    final result = await addTestToFolderInStorage(
        groupName: groupName,
        folderName: folderName,
        apiRequest: apiRequest,
        apiResponse: apiResponse);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      int index = _groups.indexWhere((element) => element.name == groupName);
      _groups.removeWhere((element) => element.name == groupName);
      _groups.insert(index, r);
      notifyListeners();
    });
  }

  Future<void> deleteTestFromFolder(
      {required String folderName,
      required String groupName,
      required APIRequest apiRequest,
      required APIResponse apiResponse,
      required BuildContext context}) async {
    final result = await deleteTestFromFolderStorage(
      groupName: groupName,
      folderName: folderName,
      apiRequest: apiRequest,
      apiResponse: apiResponse,
    );

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups
          .firstWhere((element) => element.name == groupName)
          .folders
          .firstWhere((element) => element.name == folderName)
          .requests
          .removeWhere((element) => element.key == apiRequest);
      notifyListeners();
    });
  }

  Future<void> deleteFolderFromGroup(
      {required String folderName,
      required String groupName,
      required BuildContext context}) async {
    final result = await deleteFolderFromGroupStorage(
      groupName: groupName,
      folderName: folderName,
    );

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups
          .firstWhere((element) => element.name == groupName)
          .folders
          .removeWhere((element) => element.name == folderName);

      notifyListeners();
    });
  }

  List<Group> get getGroups => _groups;
  Folder? get getSelectedFolder => _selectedFolder;
  String get getSelectedGroupName => _selectedGroupName;
}
