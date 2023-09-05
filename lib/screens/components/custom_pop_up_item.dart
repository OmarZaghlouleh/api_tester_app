import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/styles.dart';

import 'package:flutter/material.dart';

class CustomPopUpMenuItem extends StatelessWidget {
  const CustomPopUpMenuItem(
      {super.key,
      required this.title,
      required this.iconData,
      this.rowColor = AppColors.popUpRowcolor});

  final String title;
  final IconData iconData;
  final Color rowColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: rowColor,
        ),
        10.wh(),
        Expanded(
            child: Text(title,
                style: appTextStyle(fontSize: 18, color: rowColor))),
      ],
    );
  }
}
