import 'dart:convert';

import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/action_button.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatefulWidget {
  ResponseScreen({super.key, required this.response});

  APIResponse response;

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
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
            setState(() {
              widget.response = r;
            });
          });
        },
        title: "Retest",
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 20, bottom: 8),
            child: Image.asset("assets/icons/api-icon.png"),
          ),
        ),
        title: Text(
          "Response",
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
                    child: Text(
                      widget.response.body.isNotEmpty &&
                              widget.response.isException == false
                          ? (jsonDecode(widget.response.body) as Map).print()
                          : widget.response.body,
                      style: GoogleFonts.lalezar(
                        //fontWeight: FontWeight.w600,
                        fontSize: 18,
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
