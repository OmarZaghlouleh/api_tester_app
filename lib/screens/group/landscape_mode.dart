// ignore_for_file: use_build_context_synchronously

import 'package:api_tester_app/classes/folder.dart';
import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/screens/components/custom_pop_up_item.dart';
import 'package:api_tester_app/screens/components/dialog.dart';
import 'package:api_tester_app/screens/components/test_card.dart';
import 'package:api_tester_app/screens/home/home_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:api_tester_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

class GroupsLandscapeMode extends StatelessWidget {
  const GroupsLandscapeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, groupSettings, child) => groupSettings
              .getGroups.isEmpty
          ? Center(
              child: Text(
              "There are no groups to show\n Click \" + Add group \" button to add a new group.",
              textAlign: TextAlign.center,
              style: GoogleFonts.laila(
                fontWeight: FontWeight.w800,
                color: AppColors.unSelectedgroupFolderColor,
                fontSize: 15,
              ),
            ))
          : Row(
              children: [
                Expanded(
                  child: ListView(
                    children: groupSettings.getGroups
                        .map(
                          (group) => ExpansionTile(
                            onExpansionChanged: (value) {
                              if (value) {
                                groupSettings.changeSelectedGroup(group: group);
                              }
                            },
                            leading: const Icon(Icons.folder_copy_rounded),
                            iconColor: AppColors.groupColor,
                            textColor: AppColors.groupColor,
                            title: Text(group.name),
                            trailing: PopupMenuButton(
                              color: AppColors.popupbuttonBackgroundColor,
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
                                    iconData: Icons.create_new_folder_rounded,
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: AppConstants.delete,
                                  child: CustomPopUpMenuItem(
                                    title: "Delete",
                                    rowColor: AppColors.errorColor,
                                    iconData: Icons.delete,
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                switch (value) {
                                  case AppConstants.delete:
                                    await groupSettings.deleteGroup(
                                        context: context, name: group.name);
                                    break;
                                  case AppConstants.add:
                                    showNameDialog(
                                        context: context,
                                        title: "Folder name",
                                        function: (
                                            {required String name}) async {
                                          await Provider.of<GroupsProvider>(
                                                  context,
                                                  listen: false)
                                              .addFolder(
                                            context: context,
                                            folderName: name,
                                            group: group,
                                          );
                                        });
                                    break;
                                  default:
                                }
                              },
                            ),
                            children: group.folders
                                .map(
                                  (folder) => InkWell(
                                    onTap: () {
                                      groupSettings.setSelectedFolder(
                                          folder: folder,
                                          groupName: group.name);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(
                                                  Icons.folder_rounded,
                                                  color: folder.hashCode ==
                                                          groupSettings
                                                              .getSelectedFolder
                                                              .hashCode
                                                      ? AppColors
                                                          .selectedgroupFolderColor
                                                      : AppColors
                                                          .unSelectedgroupFolderColor),
                                              title: Text(
                                                folder.name,
                                                style: appTextStyle(
                                                    fontSize: 19,
                                                    color: folder.hashCode ==
                                                            groupSettings
                                                                .getSelectedFolder
                                                                .hashCode
                                                        ? AppColors
                                                            .selectedgroupFolderColor
                                                        : AppColors
                                                            .unSelectedgroupFolderColor),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await groupSettings
                                                  .deleteFolderFromGroup(
                                                      context: context,
                                                      groupName: group.name,
                                                      folderName: folder.name);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: AppColors.errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: VerticalDivider(
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Provider.of<GroupsProvider>(context, listen: true)
                              .getSelectedFolder ==
                          null
                      ? Center(
                          child: Text(
                          "Select a folder to show the details",
                          style: GoogleFonts.laila(
                            fontWeight: FontWeight.w800,
                            color: AppColors.unSelectedgroupFolderColor,
                            fontSize: 15,
                          ),
                        ))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<GroupsProvider, Folder?>(
                              selector: (p0, p1) => p1.getSelectedFolder,
                              builder: (context, folder, child) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      folder!.name,
                                      style: GoogleFonts.laila(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.primaryColor),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                addToFolder: true,
                                                folderName: folder.name,
                                                groupName:
                                                    Provider.of<GroupsProvider>(
                                                            context,
                                                            listen: false)
                                                        .getSelectedGroupName,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "+ Add test",
                                          style: GoogleFonts.laila(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.buttonTextColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Tests
                            Expanded(
                              child: Selector<GroupsProvider, Folder?>(
                                selector: (p0, p1) => p1.getSelectedFolder,
                                builder: (context, folder, child) => folder!
                                        .requests.isNotEmpty
                                    ? LayoutBuilder(
                                        builder: (context, constraints) =>
                                            ListView.builder(
                                          itemCount: folder.requests.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Row(
                                            children: [
                                              Expanded(
                                                child: Dismissible(
                                                    key: Key(index.toString()),
                                                    onDismissed: (_) async {
                                                      await Provider.of<
                                                                  GroupsProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteTestFromFolder(
                                                              index: index,
                                                              folderName: folder
                                                                  .name,
                                                              groupName: Provider.of<
                                                                          GroupsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getSelectedGroupName,
                                                              apiRequest:
                                                                  folder
                                                                      .requests[
                                                                          index]
                                                                      .key,
                                                              apiResponse:
                                                                  folder
                                                                      .requests[
                                                                          index]
                                                                      .value,
                                                              context: context);
                                                    },
                                                    child: TestCard(
                                                        fromHistory: false,
                                                        requests:
                                                            folder.requests,
                                                        index: index)),
                                              ),
                                              if (constraints.maxWidth > 600)
                                                IconButton(
                                                    onPressed: () async {
                                                      await Provider.of<
                                                                  GroupsProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteTestFromFolder(
                                                              index: index,
                                                              folderName: folder
                                                                  .name,
                                                              groupName: Provider.of<
                                                                          GroupsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getSelectedGroupName,
                                                              apiRequest:
                                                                  folder
                                                                      .requests[
                                                                          index]
                                                                      .key,
                                                              apiResponse:
                                                                  folder
                                                                      .requests[
                                                                          index]
                                                                      .value,
                                                              context: context);
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color:
                                                          AppColors.errorColor,
                                                    ))
                                            ],
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                            "Click  \"+ Add test \" button to add requests to this folder."),
                                      ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
