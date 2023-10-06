import 'package:api_tester_app/screens/components/custom_text_field.dart';
import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  KeyValueRow(
      {required this.keyController,
      required this.valueController,
      this.isValueList = false,
      this.maxLength = 25,
      this.textInputType = TextInputType.text,
      super.key});
  final TextEditingController keyController;
  final TextEditingController valueController;
  TextInputType textInputType;
  bool isValueList;
  int maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: CustomTextField(
                  label: "Key",
                  prefix: null,
                  suffix: null,
                  controller: keyController,
                  hintText: "",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 25, left: 8.0, right: 8.0),
                child: Text(":"),
              ),
              Expanded(
                flex: 4,
                child: CustomTextField(
                  textInputType: textInputType,
                  label: "Value",
                  suffix: null,
                  prefix: null,
                  controller: valueController,
                  hintText: "",
                  maxLength: maxLength,
                ),
              )
            ],
          ),
          if (isValueList == true) const Text("split each item with ','  e.g. 1,2,3"),
        ],
      ),
    );
  }
}
