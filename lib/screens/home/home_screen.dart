// ignore_for_file: use_build_context_synchronously

import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/controllers/home_provider.dart';

import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';

import 'package:api_tester_app/screens/components/drawer.dart';

import 'package:api_tester_app/screens/home/home_landscape.dart';
import 'package:api_tester_app/screens/home/home_portrait.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {this.addToFolder = false,
      this.folderName = "",
      this.groupName = "",
      super.key});

  bool addToFolder = false;
  String folderName = "";
  String groupName = "";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();

  final TextEditingController _endpointController = TextEditingController();

  @override
  void initState() {
    _ipController.addListener(() {
      Provider.of<HomeProvider>(context, listen: false)
          .setIP(ip: _ipController.text.trim());
    });
    _endpointController.addListener(() {
      Provider.of<HomeProvider>(context, listen: false)
          .setEndpoint(endpoint: _endpointController.text.trim());
    });
    super.initState();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.addToFolder ? null : const CustomDrawer(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Consumer<HomeProvider>(
        builder: (context, value, child) => ActionButton(
          isLoading: value.getIsLoading,
          function: () async {
            final result =
                await Provider.of<HomeProvider>(context, listen: false)
                    .test(context: context);
            result.fold((l) {}, (r) async {
              if (widget.addToFolder) {
                await Provider.of<GroupsProvider>(context, listen: false)
                    .addTestToFolder(
                        folderName: widget.folderName,
                        groupName: widget.groupName,
                        apiRequest: value.getRequestData,
                        apiResponse: r,
                        context: context);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResponseScreen(response: r),
                ),
              );
            });
          },
          title: "Test",
        ),
      ),
      appBar: customAppBar(
        title: "API Tester",
        isLeadingActive: false,
        context: context,
      ),
      body: LayoutBuilder(
        builder: (context, p1) => p1.maxWidth > 600
            ? HomeLandscape(
                endpointController: _endpointController,
                ipController: _ipController)
            : HomePortrait(
                endpointController: _endpointController,
                ipController: _ipController),
      ),
    );
  }
}
