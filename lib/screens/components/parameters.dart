import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/screens/components/key_value_row.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class ParametersComponent extends StatelessWidget {
  const ParametersComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(title: "Parameters"),
            TextButton(
              onPressed: () {
                Provider.of<HomeProvider>(context, listen: false)
                    .addParametersController();
              },
              child: const Text(
                "+ Field",
                style: TextStyle(color: AppColors.textButtonColor),
              ),
            )
          ],
        ),
        Consumer<HomeProvider>(
          builder: (context, value, child) => ListBody(
            children: value.getParametersControllers.entries
                .map(
                  (e) => Row(
                    children: [
                      Expanded(
                        child: KeyValueRow(
                          keyController: e.key,
                          valueController: e.value,
                        ),
                      ),
                      Consumer<HomeProvider>(
                        builder: (context, value, child) => IconButton(
                          onPressed: () {
                            value.deleteParametersController(key: e.key);
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        // Consumer<HomeProvider>(
        //   builder: (context, value, child) => Text(
        //     value.getRequestData.parameters.isEmpty
        //         ? ""
        //         : "header: ${value.getRequestData.header.print()}",
        //     textAlign: TextAlign.start,
        //   ),
        // ),
      ],
    );
  }
}
