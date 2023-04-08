import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final TextEditingController _nameController = TextEditingController();
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  content: CustomTextField(
                    label: "Group name",
                    prefix: null,
                    suffix: IconButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await Provider.of<GroupsProvider>(context,
                                listen: false)
                            .addGroup(
                                context: context,
                                name: _nameController.text.trim());
                        _nameController.clear();
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        color: AppColors.accentColor,
                      ),
                    ),
                    controller: _nameController,
                    hintText: "",
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_rounded,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<GroupsProvider>(
          builder: (context, value, child) => Column(
            children: value.getGroups
                .map(
                  (group) => ExpansionTile(
                    title: Text(group.name),
                    children: group.folders
                        .map(
                          (e) => Text(
                            e.name,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
