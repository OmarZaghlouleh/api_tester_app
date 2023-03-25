import 'package:flutter/material.dart';

extension WHExtension on num {
  Widget wh() => SizedBox(
        height: toDouble(),
        width: toDouble(),
      );
}
