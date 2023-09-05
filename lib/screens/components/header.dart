import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/extensions/map_print_extension.dart';
import 'package:api_tester_app/screens/components/key_value_row.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(title: "Header"),
            TextButton(
              onPressed: () {
                Provider.of<HomeProvider>(context, listen: false)
                    .addHeaderController();
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
            children: value.getHeaderControllers.entries
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
                            value.deleteHeaderController(key: e.key);
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
      ],
    );
  }
}
