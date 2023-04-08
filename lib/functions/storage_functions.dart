import 'dart:convert';
import 'dart:developer';

import 'package:api_tester_app/classes/Failure.dart';
import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/hive_map.dart';
import 'package:api_tester_app/functions/snackbar.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

Future<Either<Failure, Group>> addGroupToStorage(
    {required String name, required BuildContext context}) async {
  try {
    final box = Hive.box(AppConstants.groupsBox);

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
    if (kDebugMode) log("Save Group $e");
    return Left(Failure(message: e.toString()));
  }
}
