import 'dart:developer';

import 'package:api_tester_app/classes/folder.dart';
import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/custom_pop_up_item.dart';
import 'package:api_tester_app/screens/components/delete_dialog.dart';
import 'package:api_tester_app/screens/components/dialog.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
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
    return Row(
      children: [
        Consumer<GroupsProvider>(
          builder: (context, groupSettings, child) => groupSettings
                  .getGroups.isEmpty
              ? const Expanded(child: Center(child: Text("No Groups")))
              : Expanded(
                  child: ListView(
                    children: groupSettings.getGroups
                        .map(
                          (group) => ExpansionTile(
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
                                      child: ListTile(
                                        trailing: PopupMenuButton(
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
                                              value: AppConstants.delete,
                                              child: CustomPopUpMenuItem(
                                                title: "Delete folder",
                                                iconData: Icons.delete_rounded,
                                                rowColor: AppColors.errorColor,
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) async {
                                            switch (value) {
                                              case AppConstants.delete:
                                                await Provider.of<
                                                            GroupsProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteFolderFromGroup(
                                                        folderName: folder.name,
                                                        groupName: group.name,
                                                        context: context);
                                                break;
                                              default:
                                            }
                                          },
                                        ),
                                        leading: Icon(Icons.folder_rounded,
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
                                  ),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
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
              ? const Center(child: Text("Select a folder to show the details"))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<GroupsProvider, Folder?>(
                      selector: (p0, p1) => p1.getSelectedFolder,
                      builder: (context, folder, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        addToFolder: true,
                                        folderName: folder.name,
                                        groupName: Provider.of<GroupsProvider>(
                                                context,
                                                listen: false)
                                            .getSelectedGroupName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "+ Add a test",
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
                    Expanded(
                      child: Selector<GroupsProvider, Folder?>(
                        selector: (p0, p1) => p1.getSelectedFolder,
                        builder: (context, folder, child) => folder!
                                .requests.isNotEmpty
                            ? ListView.builder(
                                itemCount: folder.requests.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Dismissible(
                                    key: Key(
                                        folder.requests.hashCode.toString()),
                                    onDismissed: (_) {
                                      showDeleteDialog(
                                          context: context,
                                          confirmFunction: () async {
                                            await Provider.of<GroupsProvider>(
                                                    context,
                                                    listen: false)
                                                .deleteTestFromFolder(
                                                    folderName: folder.name,
                                                    groupName: Provider.of<
                                                                GroupsProvider>(
                                                            context,
                                                            listen: false)
                                                        .getSelectedGroupName,
                                                    apiRequest: folder
                                                        .requests[index].key,
                                                    apiResponse: folder
                                                        .requests[index].value,
                                                    context: context);
                                          });
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        folder.requests.isNotEmpty
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    width: 1.5,
                                                    color: (folder
                                                                .requests[index]
                                                                .value
                                                                .isException ||
                                                            folder
                                                                    .requests[
                                                                        index]
                                                                    .value
                                                                    .statusCode >=
                                                                400)
                                                        ? AppColors.errorColor
                                                        : AppColors
                                                            .successColor,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin:
                                                    const EdgeInsets.all(12),
                                                child: Column(
                                                  children: [
                                                    RequestRow(
                                                        textColor: Colors.black,
                                                        title: "URL",
                                                        data: folder
                                                            .requests[index]
                                                            .key
                                                            .url),
                                                    RequestRow(
                                                      textColor: Colors.black,
                                                      title: "Headers",
                                                      data: folder
                                                              .requests[index]
                                                              .key
                                                              .header
                                                              .isEmpty
                                                          ? "Empty"
                                                          : folder
                                                              .requests[index]
                                                              .key
                                                              .header
                                                              .print(),
                                                    ),
                                                    RequestRow(
                                                        textColor: Colors.black,
                                                        title: "Body",
                                                        data: folder
                                                                .requests[index]
                                                                .key
                                                                .body
                                                                .isEmpty
                                                            ? "Empty"
                                                            : folder
                                                                .requests[index]
                                                                .key
                                                                .body
                                                                .print()),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        folder.requests.isNotEmpty
                                            ? CircleAvatar(
                                                backgroundColor: (folder
                                                            .requests[index]
                                                            .value
                                                            .isException ||
                                                        folder
                                                                .requests[index]
                                                                .value
                                                                .statusCode >=
                                                            400)
                                                    ? AppColors.errorColor
                                                    : AppColors.successColor,
                                                child: FittedBox(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Text(
                                                      folder.requests[index].key
                                                          .method.name,
                                                      style: GoogleFonts.laila(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
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
    );
  }
}
