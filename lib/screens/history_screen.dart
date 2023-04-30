import 'package:api_tester_app/controllers/history_provider.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
import 'package:api_tester_app/screens/response_screen.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    Future.delayed(Duration.zero, () {
      Provider.of<HistoryProvider>(context, listen: false).setRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "History", context: context),
      body: Consumer<HistoryProvider>(
        builder: (context, value, child) => ListView.builder(
          itemCount: value.getHistory.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResponseScreen(
                  response: value.getHistory[index].value.value,
                  fromHistory: true,
                  request: value.getHistory[index].value.key,
                ),
              ),
            ),
            child: Dismissible(
              key: Key(value.getHistory[index].key),
              onDismissed: (direction) =>
                  value.delete(key: value.getHistory[index].key),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.5,
                          color: (value.getHistory[index].value.value
                                      .isException ||
                                  value.getHistory[index].value.value
                                          .statusCode >=
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
                              data: value.getHistory[index].value.key.url),
                          RequestRow(
                            title: "Headers",
                            data:
                                value.getHistory[index].value.key.header.isEmpty
                                    ? "Empty"
                                    : value.getHistory[index].value.key.header
                                        .print(),
                          ),
                          RequestRow(
                              title: "Body",
                              data:
                                  value.getHistory[index].value.key.body.isEmpty
                                      ? "Empty"
                                      : value.getHistory[index].value.key.body
                                          .print()),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: (value
                                  .getHistory[index].value.value.isException ||
                              value.getHistory[index].value.value.statusCode >=
                                  400)
                          ? AppColors.errorColor
                          : AppColors.successColor,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            value.getHistory[index].value.key.method.name,
                            style: GoogleFonts.laila(
                              fontWeight: FontWeight.w100,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
