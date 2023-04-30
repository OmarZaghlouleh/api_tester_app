import 'package:api_tester_app/screens/group/groups_screen.dart';
import 'package:api_tester_app/utils/assets.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/styles.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../enums/icon_size.dart';
import '../history_screen.dart';
import 'app_icon.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        backgroundColor: AppColors.drawerColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: AppIcon(appIconSize: AppIconSize.small),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                title: Text(
                  "History",
                  style: appTextStyle(
                    fontSize: 18,
                    color: AppColors.drawerTextColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.history_rounded,
                  color: AppColors.drawerTextColor,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupsScreen(),
                    ),
                  );
                },
                title: Text(
                  "Groups",
                  style: appTextStyle(
                    fontSize: 18,
                    color: AppColors.drawerTextColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.folder_copy_rounded,
                  color: AppColors.drawerTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
