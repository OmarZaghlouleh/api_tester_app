import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
    {required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.errorColor,
      content: Text(message),
    ),
  );
}
