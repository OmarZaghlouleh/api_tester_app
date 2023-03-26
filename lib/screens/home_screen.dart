import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/body.dart';
import 'package:api_tester_app/screens/components/check.dart';
import 'package:api_tester_app/screens/components/custom_drop_down.dart';
import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:api_tester_app/screens/components/header.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ActionButton(
        function: () async {
          final result = await Provider.of<HomeProvider>(context, listen: false)
              .test(context: context);
          result.fold((l) {}, (r) {
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8, left: 20, bottom: 8),
          child: Image.asset("assets/icons/api-icon.png"),
        ),
        title: Text(
          "API Tester",
          style: GoogleFonts.bungee(
            color: AppColors.primaryColor,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.appBarBackgroundColor,
        elevation: 0,
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
                  const TitleText(title: "URL"),
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
                  controller: _endpointController,
                  hintText: "e.g. user/register"),
              20.wh(),
              Consumer<HomeProvider>(
                builder: (context, value, child) => Text(
                  value.getUrl,
                ),
              ),
              20.wh(),
              Row(
                children: [
                  const TitleText(title: "Method"),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) => Row(
                      children: [
                        // const Text("Select type: "),
                        10.wh(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CustomDropDownButton<RequestTypes>(
                            value: value.getMethod,
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
                                            color: value.getMethod == method
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
                      value.getMethod == RequestTypes.get
                          ? const SizedBox.shrink()
                          : const BodyComponent()),
            ],
          ),
        ),
      ),
    );
  }
}
