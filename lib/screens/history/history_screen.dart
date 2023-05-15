import 'package:api_tester_app/controllers/history_provider.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/request_row.dart';
import 'package:api_tester_app/screens/history/history_details.dart';
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
        builder: (context, value, child) => value.getHistory.isEmpty
            ? const Center(child: Text("No History"))
            : LayoutBuilder(
                builder: (context, constraints) => constraints.maxWidth < 600
                    ? ListView.builder(
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
                                        color: (value.getHistory[index].value
                                                    .value.isException ||
                                                value.getHistory[index].value
                                                        .value.statusCode >=
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
                                            textColor: Colors.black,
                                            title: "URL",
                                            data: value.getHistory[index].value
                                                .key.url),
                                        RequestRow(
                                          textColor: Colors.black,
                                          title: "Headers",
                                          data: value.getHistory[index].value
                                                  .key.header.isEmpty
                                              ? "Empty"
                                              : value.getHistory[index].value
                                                  .key.header
                                                  .print(),
                                        ),
                                        RequestRow(
                                            textColor: Colors.black,
                                            title: "Body",
                                            data: value.getHistory[index].value
                                                    .key.body.isEmpty
                                                ? "Empty"
                                                : value.getHistory[index].value
                                                    .key.body
                                                    .print()),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: (value.getHistory[index]
                                                .value.value.isException ||
                                            value.getHistory[index].value.value
                                                    .statusCode >=
                                                400)
                                        ? AppColors.errorColor
                                        : AppColors.successColor,
                                    child: FittedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          value.getHistory[index].value.key
                                              .method.name,
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
                      )
                    : GridView.count(
                        crossAxisCount: 4,
                        children: value.getHistory
                            .map(
                              (e) => Dismissible(
                                key: Key(e.key),
                                onDismissed: (direction) =>
                                    value.delete(key: e.key),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResponseScreen(
                                        response: e.value.value,
                                        fromHistory: true,
                                        request: e.value.key,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 1.5,
                                              color:
                                                  (e.value.value.isException ||
                                                          e.value.value
                                                                  .statusCode >=
                                                              400)
                                                      ? AppColors.errorColor
                                                      : AppColors.successColor,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(12),
                                          child: Column(
                                            //mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: RequestRow(
                                                    textColor: Colors.black,
                                                    title: "URL",
                                                    data: e.value.key.url),
                                              ),
                                              if (e.value.key.header
                                                  .print()
                                                  .isNotEmpty)
                                                Expanded(
                                                  child: RequestRow(
                                                    textColor: Colors.black,
                                                    title: "Headers",
                                                    data: e.value.key.header
                                                            .isEmpty
                                                        ? "Empty"
                                                        : e.value.key.header
                                                            .print(),
                                                  ),
                                                ),
                                              if (e.value.key.body
                                                  .print()
                                                  .isNotEmpty)
                                                Expanded(
                                                  child: RequestRow(
                                                      textColor: Colors.black,
                                                      title: "Body",
                                                      data: e.value.key.body
                                                              .isEmpty
                                                          ? "Empty"
                                                          : e.value.key.body
                                                              .print()),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: IconButton(
                                                icon: const Icon(Icons
                                                    .remove_red_eye_rounded),
                                                onPressed: () {
                                                  showHistoryRequestDetails(
                                                      request: e.value.key,
                                                      context: context);
                                                },
                                              ),
                                            )),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: (e.value.value
                                                        .isException ||
                                                    e.value.value.statusCode >=
                                                        400)
                                                ? AppColors.errorColor
                                                : AppColors.successColor,
                                            child: FittedBox(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                  e.value.key.method.name,
                                                  style: GoogleFonts.laila(
                                                    fontWeight: FontWeight.w100,
                                                    fontSize: 15,
                                                  ),
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
                            )
                            .toList(),
                      )),
      ),
    );
  }
}
