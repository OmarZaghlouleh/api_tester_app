import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
  });
  final List<DropdownMenuItem<T>> items;
  final Function onChanged;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DropdownButton<T>(
        value: value,
        elevation: 3,
        dropdownColor: AppColors.dropDownBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        items: items,
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
