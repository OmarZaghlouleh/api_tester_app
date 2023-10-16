// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/extensions/update_list_element+extension.dart';
import 'package:api_tester_app/functions/snackbar.dart';
import 'package:api_tester_app/functions/storage_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../classes/folder.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> _groups = [];
  Folder? _selectedFolder;
  Group? _selectedGroup;
  // String _selectedGroupName = "";

  void setSelectedFolder({required Folder folder, required Group group}) {
    log(folder.requests.toString());
    _selectedGroup = group;
    _selectedFolder = folder;
    log("dsdsadd");
    notifyListeners();
  }

  void changeSelectedFolder({required Folder? folder}) {
    _selectedFolder = folder;
    log(_selectedFolder!.requests.length.toString());
    notifyListeners();
  }

  void changeSelectedGroup({required Group? group}) {
    _selectedGroup = group;
    if (_selectedGroup!.folders.isNotEmpty) {
      _selectedFolder = group!.folders.first;
    } else {
      _selectedFolder = null;
    }
    notifyListeners();
  }

  Future<void> fetchGroups({required BuildContext context}) async {
    final result = await getGroupsFromStorage();

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      if (kDebugMode) log(r.toString());
      _groups = r;
      if (_groups.isNotEmpty) {
        _selectedGroup = _groups.first;
        if (_selectedGroup!.folders.isNotEmpty)
          _selectedFolder = _selectedGroup!.folders.first;
      }
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
      _selectedGroup = r;
      _selectedFolder = null;
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
      _selectedGroup = r;
      _selectedFolder = r.folders.last;
      _groups.update(key: group, newValue: r);
      notifyListeners();
    });
  }

  Future<void> deleteGroup(
      {required BuildContext context, required String name}) async {
    final result = await deleteGroupFromStorage(name: name);
    if (getSelectedGroup != null && getSelectedGroup!.name == name) {
      _selectedGroup = null;
      notifyListeners();
    }

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups.removeWhere((element) => element.name == name);
      if (_groups.isNotEmpty) {
        _selectedGroup = _groups.first;
        if (_selectedGroup!.folders.isNotEmpty)
          _selectedFolder = _selectedGroup!.folders.first;
      } else {
        _selectedFolder = null;
      }
      notifyListeners();
    });
  }

  Future<void> deleteFolderFromGroup(
      {required BuildContext context,
      required String folderName,
      required String groupName}) async {
    final result = await deleteFolderFromGroupStorage(
        folderName: folderName, groupName: groupName);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      if (getSelectedFolder != null && getSelectedFolder!.name == folderName)
        _selectedFolder = null;
      _groups
          .firstWhere((element) => element.name == groupName)
          .folders
          .removeWhere((element) => element.name == folderName);
      notifyListeners();
    });
  }

  Future<void> addTestToFolder(
      {required String folderName,
      required String groupName,
      required APIRequest apiRequest,
      required APIResponse apiResponse,
      required BuildContext context}) async {
    log(groupName + "aaaaaaa");
    final result = await addTestToFolderInStorage(
        groupName: groupName,
        folderName: folderName,
        apiRequest: apiRequest,
        apiResponse: apiResponse);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups
          .firstWhere((element) => element.name == groupName)
          .folders
          .firstWhere((element) => element.name == folderName)
          .requests
          .add(MapEntry(apiRequest, apiResponse));
      notifyListeners();
    });
  }

  Future<void> deleteTestFromFolder(
      {required String folderName,
      required String groupName,
      required int index,
      required APIRequest apiRequest,
      required APIResponse apiResponse,
      required BuildContext context}) async {
    log(groupName + "asdasdsad");
    final result = await deleteTestFromFolderInStorage(
        index: index,
        groupName: groupName,
        folderName: folderName,
        apiRequest: apiRequest,
        apiResponse: apiResponse);

    result.fold((l) {
      showCustomSnackBar(context: context, message: l.message);
    }, (r) {
      _groups
          .firstWhere((element) => element.name == groupName)
          .folders
          .firstWhere((element) => element.name == folderName)
          .requests
          .removeAt(index);
      notifyListeners();
    });
  }

  List<Group> get getGroups => _groups;
  Folder? get getSelectedFolder => _selectedFolder;
  Group? get getSelectedGroup => _selectedGroup;
  // String get getSelectedGroupName => _selectedGroupName;
}
