import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestCard extends StatelessWidget {
  const TestCard({
    super.key,
    required this.requests,
    required this.index,
    required this.fromHistory,
  });

  final List<MapEntry<APIRequest, APIResponse>> requests;
  final int index;
  final bool fromHistory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResponseScreen(
              response: requests.elementAt(index).value,
              fromHistory: fromHistory,
              request: requests.elementAt(index).key,
            ),
          ),
        );
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ResponseScreen(
        //       response: value.getHistory[index].value.value,
        //       fromHistory: true,
        //       request: value.getHistory[index].value.key,
        //     ),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            requests.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1.5,
                        color: (requests.elementAt(index).value.isException ||
                                requests.elementAt(index).value.statusCode >=
                                    400)
                            ? AppColors.errorColor
                            : AppColors.successColor,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        RequestRow(
                            title: "URL",
                            data: requests.elementAt(index).key.url),
                        RequestRow(
                          title: "Headers",
                          data: requests.elementAt(index).key.header.isEmpty
                              ? "Empty"
                              : requests.elementAt(index).key.header.print(),
                        ),
                        RequestRow(
                            title: "Body",
                            data: requests.elementAt(index).key.body.isEmpty
                                ? "Empty"
                                : requests.elementAt(index).key.body.print()),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            requests.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: (requests
                                .elementAt(index)
                                .value
                                .isException ||
                            requests.elementAt(index).value.statusCode >= 400)
                        ? AppColors.errorColor
                        : AppColors.successColor,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          requests.elementAt(index).key.method.name,
                          style: GoogleFonts.laila(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
