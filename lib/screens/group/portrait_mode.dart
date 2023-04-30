import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/screens/components/custom_pop_up_item.dart';
import 'package:api_tester_app/screens/components/dialog.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/constants.dart';
import 'package:api_tester_app/utils/styles.dart';
import 'package:flutter/material.dart';

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
                          leading: const Icon(
                            Icons.folder_rounded,
                            color: AppColors.accentColor,
                          ),
                          title: Text(
                            folder.name,
                            style: appTextStyle(
                                fontSize: 19, color: AppColors.accentColor),
                          ),
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
