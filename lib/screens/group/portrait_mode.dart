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

class GroupsPortraitMode extends StatelessWidget {
  const GroupsPortraitMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, groupSettings, child) => Column(
        children: groupSettings.getGroups
            .map(
              (group) => ExpansionTile(
                leading: const Icon(Icons.folder_copy_rounded),
                iconColor: AppColors.accentColor,
                textColor: AppColors.accentColor,
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
                            function: ({required String name}) async {
                              await Provider.of<GroupsProvider>(context,
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
                      (folder) => Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: ExpansionTile(
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
                                  title: "Add a test",
                                  iconData: Icons.http,
                                ),
                              ),
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
                                case AppConstants.add:
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        addToFolder: true,
                                        folderName: folder.name,
                                        groupName: group.name,
                                      ),
                                    ),
                                  );
                                  break;
                                case AppConstants.delete:
                                  await Provider.of<GroupsProvider>(context,
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
                          leading: const Icon(
                            Icons.folder_rounded,
                            color: AppColors.accentColor,
                          ),
                          title: Text(
                            folder.name,
                            style: appTextStyle(
                                fontSize: 19, color: AppColors.accentColor),
                          ),
                          children: folder.requests
                              .map(
                                (request) => Dismissible(
                                  key: Key(folder.requests.hashCode.toString()),
                                  onDismissed: (_) {
                                    showDeleteDialog(
                                        context: context,
                                        confirmFunction: () async {
                                          await Provider.of<GroupsProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteTestFromFolder(
                                                  folderName: folder.name,
                                                  groupName: group.name,
                                                  apiRequest: request.key,
                                                  apiResponse: request.value,
                                                  context: context);
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                                    color: (request.value
                                                                .isException ||
                                                            request.value
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
                                                        data: request.key.url),
                                                    RequestRow(
                                                      textColor: Colors.black,
                                                      title: "Headers",
                                                      data: request.key.header
                                                              .isEmpty
                                                          ? "Empty"
                                                          : request.key.header
                                                              .print(),
                                                    ),
                                                    RequestRow(
                                                        textColor: Colors.black,
                                                        title: "Body",
                                                        data: request.key.body
                                                                .isEmpty
                                                            ? "Empty"
                                                            : request.key.body
                                                                .print()),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        folder.requests.isNotEmpty
                                            ? CircleAvatar(
                                                backgroundColor: (request.value
                                                            .isException ||
                                                        request.value
                                                                .statusCode >=
                                                            400)
                                                    ? AppColors.errorColor
                                                    : AppColors.successColor,
                                                child: FittedBox(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: Text(
                                                      request.key.method.name,
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
                              .toList(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
