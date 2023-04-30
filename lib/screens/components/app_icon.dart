import 'package:api_tester_app/enums/icon_size.dart';
import 'package:api_tester_app/utils/assets.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.appIconSize});

  final AppIconSize appIconSize;

  @override
  Widget build(BuildContext context) {
    switch (appIconSize) {
      case AppIconSize.large:
        return Image.asset(AppAssets.largeAppIcon);
      case AppIconSize.small:
        return Image.asset(AppAssets.smallAppIcon);
    }
  }
}
