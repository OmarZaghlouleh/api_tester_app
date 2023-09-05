// ignore_for_file: use_build_context_synchronously

import 'package:api_tester_app/controllers/groups_provider.dart';
import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/body.dart';
import 'package:api_tester_app/screens/components/check.dart';
import 'package:api_tester_app/screens/components/custom_drop_down.dart';
import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:api_tester_app/screens/components/drawer.dart';
import 'package:api_tester_app/screens/components/header.dart';
import 'package:api_tester_app/screens/components/parameters.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
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
        // actions: [
        //   IconButton(
        //     onPressed: () {

        //     },
        //     icon: const Icon(
        //       Icons.history,
        //       color: AppColors.primaryColor,
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TitleText(title: "URL"),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) => StatusCheck(
                        isTrue: value.getOverAllUrlStatus,
                        message: value.getOverAllUrlStatus
                            ? "Valid url"
                            : "Invalid url"),
                  ),
                ],
              ),
              Row(
                children: [
                  Consumer<HomeProvider>(
                    builder: (context, value, child) =>
                        CustomDropDownButton<HttpTypes>(
                      items: HttpTypes.values
                          .map(
                            (type) => DropdownMenuItem<HttpTypes>(
                              value: type,
                              child: Text(
                                type.name,
                                style: Theme.of(context)
                                    .dropdownMenuTheme
                                    .textStyle!
                                    .copyWith(
                                      color: type == value.getHttpType
                                          ? AppColors.dropDownSelectedColor
                                          : AppColors.dropDownUnSelectedColor,
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                      value: value.getHttpType,
                      onChanged: (HttpTypes? type) =>
                          value.setHttpType(type: type ?? HttpTypes.https),
                    ),
                  ),
                  10.wh(),
                  Expanded(
                    child: CustomTextField(
                        label: "IP",
                        suffix: null,
                        prefix: null,
                        controller: _ipController,
                        hintText: "e.g. 127.0.0.1:8000 , localhost:8000,..."),
                  ),
                ],
              ),
              20.wh(),
              CustomTextField(
                  label: "Endpoint",
                  prefix: null,
                  suffix: null,
                  controller: _endpointController,
                  hintText: "e.g. user/register"),
              20.wh(),
              const ParametersComponent(),
              20.wh(),
              Row(
                children: [
                  TitleText(title: "Method"),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) => Row(
                      children: [
                        // const Text("Select type: "),
                        10.wh(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CustomDropDownButton<RequestTypes>(
                            value: value.getRequestData.method,
                            items: RequestTypes.values
                                .map(
                                  (method) => DropdownMenuItem<RequestTypes>(
                                    value: method,
                                    child: Text(
                                      method.name,
                                      style: Theme.of(context)
                                          .dropdownMenuTheme
                                          .textStyle!
                                          .copyWith(
                                            color: value.getRequestData.method ==
                                                    method
                                                ? AppColors
                                                    .dropDownSelectedColor
                                                : AppColors
                                                    .dropDownUnSelectedColor,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (RequestTypes? method) => value
                                .setMethod(method: method ?? RequestTypes.get),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              20.wh(),
              const HeaderComponent(),
              Consumer<HomeProvider>(
                builder: (context, value, child) =>
                    value.getRequestData.method == RequestTypes.get
                        ? const SizedBox.shrink()
                        : const BodyComponent(),
              ),
              const Divider(
                  color: AppColors.primaryColor, endIndent: 50, indent: 50),
              TitleText(title: "Request:"),
              Consumer<HomeProvider>(
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      if (value.getRequestData.url.isNotEmpty)
                        RequestRow(
                            title: "URL: ", data: value.getRequestData.url),
                      if (value.getRequestData.header.isNotEmpty)
                        RequestRow(
                            title: "Header: ",
                            data: value.getRequestData.header.print()),
                      if (value.getRequestData.body.isNotEmpty)
                        RequestRow(
                            title: "Body: ",
                            data: value.getRequestData.body.print()),
                    ],
                  ),
                ),
              ),
              75.wh(),
            ],
          ),
        ),
      ),
    );
  }
}
