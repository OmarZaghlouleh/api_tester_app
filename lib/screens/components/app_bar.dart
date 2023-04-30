import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget customAppBar({
  required String title,
  required BuildContext context,
  List<Widget> actions = const [],
  bool isLeadingActive = true,
}) {
  return AppBar(
    actions: actions,
    iconTheme: const IconThemeData(color: AppColors.errorColor),
    title: Text(
      title,
      style: GoogleFonts.bungee(
        color: AppColors.primaryColor,
        fontSize: 18,
      ),
    ),
    backgroundColor: AppColors.appBarBackgroundColor,
    elevation: 0,
  );
}
