import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/enums/http_types.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/body.dart';
import 'package:api_tester_app/screens/components/custom_drop_down.dart';
import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:api_tester_app/screens/components/header.dart';
import 'package:api_tester_app/screens/components/key_value_row.dart';
import 'package:api_tester_app/screens/components/modal_bottom_sheet.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/shadows.dart';
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
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: CustomShadow.shadows,
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
          //borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Test",
            style: TextStyle(
              color: AppColors.buttonTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
              const TitleText(title: "URL"),
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
              // 20.wh(),
              // Consumer<HomeProvider>(
              //   builder: (context, value, child) => Text(
              //     value.getIP.isNotEmpty
              //         ? "URL: ${value.getHttpType.name}://${"${value.getIP}/"}${value.getEndpoint}"
              //         : "URL: ${value.getHttpType.name}://${value.getIP}",
              //   ),
              // ),
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
              const BodyComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
