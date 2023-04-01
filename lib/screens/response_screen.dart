import 'dart:convert';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/functions/test.dart';
import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatefulWidget {
  ResponseScreen({
    super.key,
    required this.response,
    this.fromHistory = false,
    this.request,
  });

  APIResponse response;
  APIRequest? request;
  bool fromHistory = false;

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  bool _isLoading = false;
  void toggleIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ActionButton(
        isLoading: _isLoading,
        function: () async {
          toggleIsLoading();
          if (widget.fromHistory && widget.request != null) {
            final response =
                await testAPI(request: widget.request ?? APIRequest.empty());
            setState(() {
              widget.response = response;
            });
          } else {
            final result =
                await Provider.of<HomeProvider>(context, listen: false)
                    .test(context: context);
            result.fold((l) {}, (r) {
              setState(() {
                widget.response = r;
              });
            });
          }
          toggleIsLoading();
        },
        title: "Retest",
      ),
      appBar: customAppBar(title: "Response", context: context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const TitleText(title: "Status: "),
                  Text(
                    (widget.response.statusCode >= 200 &&
                            widget.response.statusCode < 300)
                        ? "Success"
                        : "Failed",
                    style: GoogleFonts.lalezar(
                      color: (widget.response.statusCode >= 200 &&
                              widget.response.statusCode < 300)
                          ? Colors.green
                          : Colors.red,
                      //fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const TitleText(title: "Status code: "),
                  Text(
                    widget.response.statusCode.toString(),
                    style: GoogleFonts.lalezar(
                      color: (widget.response.statusCode >= 200 &&
                              widget.response.statusCode < 300)
                          ? Colors.green
                          : Colors.red,
                      //fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(title: "Body: "),
                  10.wh(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.response.body,
                        style: GoogleFonts.lalezar(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
