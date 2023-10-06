
import 'package:api_tester_app/controllers/history_provider.dart';
import 'package:api_tester_app/screens/components/app_bar.dart';
import 'package:api_tester_app/screens/components/test_card.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Test {}

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
      body: LayoutBuilder(
        builder: (context, constraints) => Consumer<HistoryProvider>(
          builder: (context, value, child) => value.getHistory.isEmpty
              ? const Center(
                  child: Text("The histroy is empty."),
                )
              : ListView.builder(
                  itemCount: value.getHistory.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        child: Dismissible(
                            key: Key(value.getHistory[index].key),
                            onDismissed: (direction) =>
                                value.delete(key: value.getHistory[index].key),
                            child: TestCard(
                                fromHistory: true,
                                requests: value.getHistory
                                    .map((e) => e.value)
                                    .toList(),
                                index: index)),
                      ),
                      if (constraints.maxWidth > 600)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: IconButton(
                            onPressed: () {
                              value.delete(key: value.getHistory[index].key);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.errorColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
