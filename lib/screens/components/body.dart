import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/enums/data_type.dart';
import 'package:api_tester_app/screens/components/check.dart';
import 'package:api_tester_app/screens/components/custom_drop_down.dart';
import 'package:api_tester_app/screens/components/key_value_row.dart';
import 'package:api_tester_app/screens/components/title_text.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class BodyComponent extends StatelessWidget {
  const BodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TitleText(title: "Body"),
                Consumer<HomeProvider>(
                  builder: (context, value, child) => StatusCheck(
                      isTrue: value.getOverAllBodyStatus,
                      message: value.getOverAllBodyStatus
                          ? "Valid body"
                          : "Invalid body"),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Provider.of<HomeProvider>(context, listen: false)
                    .addBodyController(context: context);
              },
              child: const Text(
                "+ Field",
                style: TextStyle(color: AppColors.textButtonColor),
              ),
            )
          ],
        ),
        Consumer<HomeProvider>(
          builder: (context, value, child) => CheckboxListTile(
            title: const Text(
              "Encode body",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            activeColor: AppColors.accentColor,
            value: value.getRequestData.encodeBody,
            onChanged: (_) {
              value.toggleEncodedBody();
            },
          ),
        ),
        Consumer<HomeProvider>(
          builder: (context, value, child) => ListBody(
            children: value.getBodyControllers.entries
                .map(
                  (e) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                                "Row ${value.getBodyControllers.entries.toList().indexWhere((element) => element.key == e.key) + 1}: ",
                                style: Theme.of(context)
                                    .dropdownMenuTheme
                                    .textStyle!),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: CustomDropDownButton<DataType>(
                                  value: e.value,
                                  items: DataType.values
                                      .map(
                                        (type) => DropdownMenuItem<DataType>(
                                          value: type,
                                          child: Text(
                                            type.name,
                                            style: Theme.of(context)
                                                .dropdownMenuTheme
                                                .textStyle!
                                                .copyWith(
                                                  color: type == e.value
                                                      ? AppColors
                                                          .dropDownSelectedColor
                                                      : AppColors
                                                          .dropDownUnSelectedColor,
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (DataType? newDatatype) {
                                    value.updateBodyControllerDataType(
                                        context: context,
                                        dataType:
                                            newDatatype ?? DataType.string,
                                        key: e.key);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: KeyValueRow(
                              //e.key = MapEntry<TextEditingcontroller,TextEditingcontroller>
                              keyController: e.key.key,
                              valueController: e.key.value, maxLength: 5000,
                              textInputType: (e.value == DataType.int ||
                                      e.value == DataType.double)
                                  ? TextInputType.number
                                  : TextInputType.text,
                              isValueList:
                                  e.value == DataType.list ? true : false,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 25),
                            child: SizedBox(
                              width: 10,
                              height: 30,
                              child: VerticalDivider(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Consumer<HomeProvider>(
                            builder: (context, value, child) => Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: IconButton(
                                onPressed: () {
                                  value.deleteBodyController(key: e.key);
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
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
