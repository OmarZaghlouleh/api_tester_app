import 'dart:developer';

import 'package:api_tester_app/classes/Failure.dart';
import 'package:api_tester_app/classes/folder.dart';
import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/hive_map.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Save request
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

//Delete request
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

//Add Group
Future<Either<Failure, Group>> addGroupToStorage(
    {required String name, Group? group}) async {
  try {
    if (kDebugMode) log("sdsds");
    if (name.isEmpty) {
      return const Left(Failure(message: "Name connot be empty"));
    }

    final box = Hive.box(AppConstants.groupsBox);
    if (group != null) {
      Group newGroup = group;
      await box.add(newGroup.toJson());
      return Right(newGroup);
    }
    List<MapEntry> data = getHiveMapValue(box: box);
    for (var element in data) {
      if (Group.fromJson(element.value).name.toString() == name.toString()) {
        return Left(
            Failure(message: "$name is already exist, try another name."));
      }
    }
    Group newGroup = Group(name: name, folders: []);
    await box.add(newGroup.toJson());
    return Right(newGroup);
  } catch (e) {
    if (kDebugMode) log("Save Group $e");
    return Left(Failure(message: e.toString()));
  }
}

//Delete group
Future<Either<Failure, void>> deleteGroupFromStorage(
    {required String name}) async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);
    int index = data
        .indexWhere((element) => name == Group.fromJson(element.value).name);
    await box.deleteAt(index);
    return const Right(null);
  } catch (e) {
    if (kDebugMode) log("Delete Group $e");
    return Left(Failure(message: e.toString()));
  }
}

Future<Either<Failure, List<Group>>> getGroupsFromStorage() async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);
    List<Group> groups = [];

    for (var element in data) {
      groups.add(Group.fromJson(element.value));
    }
    return Right(groups);
  } catch (e) {
    if (kDebugMode) log("Get Groups $e");
    return Left(Failure(message: e.toString()));
  }
}

//Add Folder
Future<Either<Failure, Group>> addFolderToStorage(
    {required String groupName, required String folderName}) async {
  try {
    if (groupName.isEmpty || folderName.isEmpty) {
      return const Left(Failure(message: "Name connot be empty"));
    }
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);

    Group oldGroup = Group.fromJson(data
        .firstWhere(
            (element) => Group.fromJson(element.value).name == groupName)
        .value);

    for (var element in oldGroup.folders) {
      if (element.name == folderName) {
        return Left(
            Failure(message: "$folderName is already exist in this group"));
      }
    }
    oldGroup.folders.add(Folder(
        name: folderName, requests: <MapEntry<APIRequest, APIResponse>>[]));
    final deleteResult = await deleteGroupFromStorage(name: groupName);
    if (deleteResult.isRight()) {
      return await addGroupToStorage(name: groupName, group: oldGroup);
    } else {
      return const Left(Failure(message: "Something went wrong"));
    }
  } catch (e) {
    if (kDebugMode) log("Save Folder $e");
    return Left(Failure(message: e.toString()));
  }
}

//Delete folder
Future<Either<Failure, void>> deleteFolderFromGroupStorage(
    {required String folderName, required String groupName}) async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);

    Group oldGroup = Group.fromJson(data
        .firstWhere(
            (element) => Group.fromJson(element.value).name == groupName)
        .value);

    oldGroup.folders.removeWhere((element) => element.name == folderName);
    final deleteResult = await deleteGroupFromStorage(name: groupName);
    if (deleteResult.isRight()) {
      return await addGroupToStorage(name: groupName, group: oldGroup);
    } else {
      return const Left(Failure(message: "Something went wrong"));
    }
  } catch (e) {
    if (kDebugMode) log("Delete Group $e");
    return Left(Failure(message: e.toString()));
  }
}

//Add test to folder
Future<Either<Failure, Group>> addTestToFolderInStorage(
    {required String groupName,
    required String folderName,
    required APIRequest apiRequest,
    required APIResponse apiResponse}) async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);
    Group oldGroup = Group.fromJson(data
        .firstWhere(
            (element) => Group.fromJson(element.value).name == groupName)
        .value);

    int index =
        oldGroup.folders.indexWhere((element) => element.name == folderName);
    Folder oldFolder =
        oldGroup.folders.firstWhere((element) => element.name == folderName);
    oldGroup.folders.removeWhere((element) => element.name == folderName);

    oldFolder.requests.add(MapEntry(apiRequest, apiResponse));
    oldGroup.folders.insert(index, oldFolder);

    final deleteResult = await deleteGroupFromStorage(name: groupName);
    return await addGroupToStorage(name: groupName, group: oldGroup);
  } catch (e) {
    if (kDebugMode) log("Add test $e");
    return Left(Failure(message: e.toString()));
  }
}

//Delete test from folder
Future<Either<Failure, Group>> deleteTestFromFolderInStorage(
    {required String groupName,
    required String folderName,
    required APIRequest apiRequest,
    required int index,
    required APIResponse apiResponse}) async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

    List<MapEntry> data = getHiveMapValue(box: box);

    Group oldGroup = Group.fromJson(data
        .firstWhere(
            (element) => Group.fromJson(element.value).name == groupName)
        .value);

    Folder oldFolder =
        oldGroup.folders.firstWhere((element) => element.name == folderName);
    oldGroup.folders.removeWhere((element) => element.name == folderName);

    oldFolder.requests.removeAt(index);
    oldGroup.folders.add(oldFolder);

    final deleteResult = await deleteGroupFromStorage(name: groupName);
    return await addGroupToStorage(name: groupName, group: oldGroup);
  } catch (e) {
    if (kDebugMode) log("Add test $e");
    return Left(Failure(message: e.toString()));
  }
}
