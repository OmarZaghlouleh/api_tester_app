import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  KeyValueRow(
      {required this.keyController,
      required this.valueController,
      this.isValueList = false,
      this.textInputType = TextInputType.text,
      super.key});
  final TextEditingController keyController;
  final TextEditingController valueController;
  TextInputType textInputType;
  bool isValueList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              label: "Key",
              prefix: null,
              controller: keyController,
              hintText: "",
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(":"),
          ),
          if (isValueList == false)
            Expanded(
              child: CustomTextField(
                textInputType: textInputType,
                label: "Value",
                prefix: null,
                controller: valueController,
                hintText: "",
              ),
            )
        ],
      ),
    );
  }
}
