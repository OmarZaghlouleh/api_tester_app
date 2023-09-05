import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

T? getHiveMapValue<T>({required Box box}) {
  try {
    return box.toMap().entries.toList() as T;
  } catch (e) {
    return null;
  }
}
