import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/styles.dart';
import 'package:flutter/material.dart';

class RequestTitleText extends StatelessWidget {
  const RequestTitleText({required this.title, super.key});

  final String title;

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
            color: AppColors.requestTitleColor,
          ),
        ),
      ),
    );
  }
}
