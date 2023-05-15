import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_provider.dart';

void showHistoryRequestDetails(
    {required APIRequest request, required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      scrollable: true,
      backgroundColor: AppColors.popupbuttonBackgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      content: Consumer<HomeProvider>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              RequestRow(
                title: "URL: ",
                data: request.url,
                textColor: Colors.white,
              ),
              if (request.header.print().isNotEmpty)
                RequestRow(
                  title: "Header: ",
                  data: request.header.print(),
                  textColor: Colors.white,
                ),
              if (request.body.print().isNotEmpty)
                RequestRow(
                  title: "Body: ",
                  data: request.body.print(),
                  textColor: Colors.white,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
