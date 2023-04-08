import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/extensions/int_extension.dart';
import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showCustomModalBottomSheet({required BuildContext context}) {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (ctx) => Padding(
      padding: MediaQuery.of(ctx).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
                label: "Key",
                prefix: null,
                suffix: null,
                controller: _keyController,
                hintText: ""),
            10.wh(),
            CustomTextField(
                label: "Value",
                prefix: null,
                suffix: null,
                controller: _valueController,
                hintText: ""),
            15.wh(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.primaryColor),
              ),
              onPressed: () {
                // Navigator.pop(ctx);
                // Provider.of<HomeProvider>(context, listen: false).addToHeader(
                //   key: _keyController.text.trim(),
                //   value: _keyController.text.trim(),
                // );
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    ),
  );
}
