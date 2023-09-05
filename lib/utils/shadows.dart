import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomShadow {
  static Color mainColor = AppColors.primaryColor;
  static Color accentColor = AppColors.primaryColor.withOpacity(0.3);

  static const double mainOffset = 5;
  static const double accentOffset = 8;

  static List<BoxShadow> shadows = [
    //main
    BoxShadow(offset: const Offset(0, mainOffset), color: mainColor),
    BoxShadow(offset: const Offset(0, -mainOffset), color: mainColor),
    BoxShadow(offset: const Offset(mainOffset, 0), color: mainColor),
    BoxShadow(offset: const Offset(-mainOffset, 0), color: mainColor),
    //accent
    BoxShadow(offset: const Offset(0, accentOffset), color: accentColor),
    BoxShadow(offset: const Offset(0, -accentOffset), color: accentColor),
    BoxShadow(offset: const Offset(accentOffset, 0), color: accentColor),
    BoxShadow(offset: const Offset(-accentOffset, 0), color: accentColor),
  ];
}
