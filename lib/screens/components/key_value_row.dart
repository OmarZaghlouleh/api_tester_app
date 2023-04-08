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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: "Key",
                  prefix: null,
                  suffix: null,
                  controller: keyController,
                  hintText: "",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(":"),
              ),
              Expanded(
                child: CustomTextField(
                  textInputType: textInputType,
                  label: "Value",
                  suffix: null,
                  prefix: null,
                  controller: valueController,
                  hintText: "",
                ),
              )
            ],
          ),
          if (isValueList == true)
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text("split each item with ','  e.g. 1,2,3"),
            ),
        ],
      ),
    );
  }
}
