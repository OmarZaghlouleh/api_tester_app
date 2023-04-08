import 'package:api_tester_app/screens/groups_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../history_screen.dart';

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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("assets/icons/api-icon.png"),
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
                  style: GoogleFonts.lalezar(
                    color: AppColors.drawerTextColor,
                    fontSize: 18,
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
                  style: GoogleFonts.lalezar(
                    color: AppColors.drawerTextColor,
                    fontSize: 18,
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
