import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/dialog.dart';
import 'package:api_tester_app/screens/group/landscape_mode.dart';
import 'package:api_tester_app/screens/group/portrait_mode.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<GroupsProvider>(context, listen: false)
          .fetchGroups(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Groups",
        context: context,
        actions: [
          TextButton(
            onPressed: () {
              showNameDialog(
                  context: context,
                  title: "Group name",
                  function: ({required String name}) async {
                    await Provider.of<GroupsProvider>(context, listen: false)
                        .addGroup(context: context, name: name);
                  });
            },
            child: Text(
              "+ Add group",
              style: GoogleFonts.laila(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (p0, p1) => p1.maxWidth > 600
            ? const GroupsLandscapeMode()
            : const GroupsPortraitMode(),
      ),
    );
  }
}
