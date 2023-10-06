import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class TitleText extends StatelessWidget {
  TitleText(
      {required this.title, this.color = AppColors.primaryColor, super.key});

  final String title;
  Color color = AppColors.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "- $title",
          style: appTextStyle(
            fontSize: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
