// ignore_for_file: use_build_context_synchronously

import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/drawer.dart';
import 'package:api_tester_app/screens/home/home_landscape.dart';
import 'package:api_tester_app/screens/home/home_portrait.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
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
  final ScrollController _scrollController = ScrollController();

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

    _scrollController.addListener(() {
      if (_scrollController.offset != 0) {
        Provider.of<HomeProvider>(context, listen: false)
            .setScrollingState(state: true);
      } else {
        Provider.of<HomeProvider>(context, listen: false)
            .setScrollingState(state: false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _endpointController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.addToFolder ? null : const CustomDrawer(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Consumer<HomeProvider>(
        builder: (context, value, child) => LayoutBuilder(
          builder: (context, constraints) => AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: value.getIsScrolling && constraints.maxWidth > 600 ? 0 : 1,
            child: Container(
              decoration: BoxDecoration(
                  image: constraints.maxWidth < 600
                      ? null
                      : const DecorationImage(
                          image: AssetImage("assets/images/circle.png"))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ActionButton(
                  isLoading: value.getIsLoading,
                  function: () async {
                    final result =
                        await Provider.of<HomeProvider>(context, listen: false)
                            .test(context: context);
                    result.fold((l) {}, (r) async {
                      if (widget.addToFolder) {
                        await Provider.of<GroupsProvider>(context,
                                listen: false)
                            .addTestToFolder(
                                folderName: widget.folderName,
                                groupName: widget.groupName,
                                apiRequest: value.getRequestData,
                                apiResponse: r,
                                context: context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponseScreen(response: r),
                          ),
                        );
                      }
                    });
                  },
                  title: "Test",
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: customAppBar(
        title: "API Tester",
        isLeadingActive: false,
        context: context,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.primaryColor),
                ),
                onPressed: () {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.format_align_justify_rounded,
                      size: 15,
                    ),
                    10.wh(),
                    const Text("Request form"),
                  ],
                )),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          controller: _scrollController,
          child: constraints.maxWidth < 600
              ? HomePortrait(
                  endpointController: _endpointController,
                  ipController: _ipController)
              : HomeLandscape(
                  endpointController: _endpointController,
                  ipController: _ipController),
        ),
      ),
    );
  }
}
