import 'package:api_tester_app/classes/folder.dart';
import 'package:api_tester_app/classes/group.dart';
import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/custom_drop_down.dart';
import 'package:api_tester_app/screens/components/custom_pop_up_item.dart';
import 'package:api_tester_app/screens/components/dialog.dart';
import 'package:api_tester_app/screens/components/test_card.dart';
import 'package:api_tester_app/screens/home_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../components/request_row.dart';

class GroupsPortraitMode extends StatelessWidget {
  const GroupsPortraitMode({super.key});

  void init({required BuildContext context}) {
    Future.delayed(Duration.zero).then((value) {
      // Provider.of<GroupsProvider>(context, listen: false)
      //     .changeSelectedGroup(group: null);
      // Provider.of<GroupsProvider>(context, listen: false)
      //     .changeSelectedFolder(folder: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    init(context: context);
    return Consumer<GroupsProvider>(
      builder: (context, groupSettings, child) => groupSettings
              .getGroups.isEmpty
          ? Center(
              child: Text(
              "There are no groups to show.",
              style: GoogleFonts.laila(
                fontWeight: FontWeight.w800,
                color: AppColors.unSelectedgroupFolderColor,
                fontSize: 15,
              ),
            ))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  stretch: true,
                  automaticallyImplyLeading: false,
                  floating: true,
                  expandedHeight:
                      groupSettings.getSelectedFolder == null ? 130 : 250,
                  backgroundColor: Colors.transparent,
                  // toolbarHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    centerTitle: true,
                    background: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (groupSettings.getGroups.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Group",
                                    style: GoogleFonts.laila(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (groupSettings.getSelectedGroup != null)
                                    PopupMenuButton(
                                      color:
                                          AppColors.popupbuttonBackgroundColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      shadowColor: AppColors.primaryColor,
                                      elevation: 5,
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: AppConstants.add,
                                          child: CustomPopUpMenuItem(
                                            title: "Add folder",
                                            iconData:
                                                Icons.create_new_folder_rounded,
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: AppConstants.delete,
                                          child: CustomPopUpMenuItem(
                                            title:
                                                "Delete ${groupSettings.getSelectedGroup!.name}",
                                            rowColor: AppColors.errorColor,
                                            iconData: Icons.delete,
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) async {
                                        switch (value) {
                                          case AppConstants.delete:
                                            await groupSettings.deleteGroup(
                                                context: context,
                                                name: groupSettings
                                                    .getSelectedGroup!.name);
                                            break;
                                          case AppConstants.add:
                                            showNameDialog(
                                                context: context,
                                                title: "Folder name",
                                                function: (
                                                    {required String
                                                        name}) async {
                                                  await Provider.of<
                                                              GroupsProvider>(
                                                          context,
                                                          listen: false)
                                                      .addFolder(
                                                    context: context,
                                                    folderName: name,
                                                    group: groupSettings
                                                        .getSelectedGroup!,
                                                  );
                                                });
                                            break;
                                          default:
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomDropDownButton<Group>(
                              value: groupSettings.getSelectedGroup,
                              items: groupSettings.getGroups
                                  .map(
                                    (group) => DropdownMenuItem<Group>(
                                      value: group,
                                      child: Text(
                                        group.name,
                                        style: Theme.of(context)
                                            .dropdownMenuTheme
                                            .textStyle!
                                            .copyWith(
                                                color: AppColors
                                                    .dropDownSelectedColor),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newGroup) {
                                groupSettings.changeSelectedGroup(
                                    group: newGroup!);
                              },
                            ),
                          ), //Folders
                          if (groupSettings.getSelectedFolder != null &&
                              groupSettings
                                  .getSelectedGroup!.folders.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Folder",
                                        style: GoogleFonts.laila(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (groupSettings.getSelectedFolder !=
                                          null)
                                        PopupMenuButton(
                                          color: AppColors
                                              .popupbuttonBackgroundColor,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                          ),
                                          shadowColor: AppColors.primaryColor,
                                          elevation: 5,
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: AppConstants.add,
                                              child: CustomPopUpMenuItem(
                                                title: "Add test",
                                                iconData: Icons.api_rounded,
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: AppConstants.delete,
                                              child: CustomPopUpMenuItem(
                                                title:
                                                    "Delete ${groupSettings.getSelectedFolder!.name}",
                                                rowColor: AppColors.errorColor,
                                                iconData: Icons.delete,
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) async {
                                            switch (value) {
                                              case AppConstants.delete:
                                                await groupSettings
                                                    .deleteFolderFromGroup(
                                                        context: context,
                                                        groupName: groupSettings
                                                            .getSelectedGroup!
                                                            .name,
                                                        folderName: groupSettings
                                                            .getSelectedFolder!
                                                            .name);
                                                break;
                                              case AppConstants.add:
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(
                                                      addToFolder: true,
                                                      folderName: groupSettings
                                                          .getSelectedFolder!
                                                          .name,
                                                      groupName: Provider.of<
                                                                  GroupsProvider>(
                                                              context,
                                                              listen: false)
                                                          .getSelectedGroup!
                                                          .name,
                                                    ),
                                                  ),
                                                );
                                                break;
                                              default:
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomDropDownButton<Folder>(
                                      value: groupSettings.getSelectedFolder,
                                      items: groupSettings.getSelectedGroup ==
                                                  null ||
                                              groupSettings.getSelectedGroup!
                                                  .folders.isEmpty
                                          ? []
                                          : groupSettings
                                              .getSelectedGroup!.folders
                                              .map(
                                                (folder) =>
                                                    DropdownMenuItem<Folder>(
                                                  value: folder,
                                                  child: Text(
                                                    folder.name,
                                                    style: Theme.of(context)
                                                        .dropdownMenuTheme
                                                        .textStyle!
                                                        .copyWith(
                                                            color: AppColors
                                                                .dropDownSelectedColor),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (newFolder) {
                                        groupSettings.changeSelectedFolder(
                                            folder: newFolder!);
                                      }),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                if (groupSettings.getSelectedFolder != null &&
                    groupSettings.getSelectedFolder!.requests.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "There are no tests in the ${groupSettings.getSelectedFolder!.name} folder to show.",
                          style: GoogleFonts.laila(
                            fontWeight: FontWeight.w800,
                            color: AppColors.unSelectedgroupFolderColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (groupSettings.getSelectedFolder != null &&
                    groupSettings.getSelectedFolder!.requests.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tests",
                        style: GoogleFonts.laila(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                if (groupSettings.getSelectedFolder != null &&
                    groupSettings.getSelectedFolder!.requests.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => LayoutBuilder(
                        builder: (context, constraints) => Row(
                          children: [
                            Expanded(
                              child: Dismissible(
                                  key: Key(index.toString()),
                                  onDismissed: (_) async {
                                    await Provider.of<GroupsProvider>(context,
                                            listen: false)
                                        .deleteTestFromFolder(
                                            index: index,
                                            folderName: groupSettings
                                                .getSelectedFolder!.name,
                                            groupName:
                                                Provider.of<GroupsProvider>(
                                                        context,
                                                        listen: false)
                                                    .getSelectedGroupName,
                                            apiRequest: groupSettings
                                                .getSelectedFolder!
                                                .requests[index]
                                                .key,
                                            apiResponse: groupSettings
                                                .getSelectedFolder!
                                                .requests[index]
                                                .value,
                                            context: context);
                                  },
                                  child: TestCard(
                                      fromHistory: false,
                                      requests: groupSettings
                                          .getSelectedFolder!.requests,
                                      index: index)),
                            ),
                            if (constraints.maxWidth > 600)
                              IconButton(
                                  onPressed: () async {
                                    await Provider.of<GroupsProvider>(context,
                                            listen: false)
                                        .deleteTestFromFolder(
                                            index: index,
                                            folderName: groupSettings
                                                .getSelectedFolder!.name,
                                            groupName:
                                                Provider.of<GroupsProvider>(
                                                        context,
                                                        listen: false)
                                                    .getSelectedGroupName,
                                            apiRequest: groupSettings
                                                .getSelectedFolder!
                                                .requests[index]
                                                .key,
                                            apiResponse: groupSettings
                                                .getSelectedFolder!
                                                .requests[index]
                                                .value,
                                            context: context);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.errorColor,
                                  ))
                          ],
                        ),
                      ),
                      childCount:
                          groupSettings.getSelectedFolder!.requests.length,
                    ),
                  ),
              ],
            ),
    );
  }
}
