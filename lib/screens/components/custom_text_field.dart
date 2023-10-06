import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.label,
    required this.prefix,
    required this.suffix,
    required this.controller,
    required this.hintText,
    this.onSubmit,
    this.textInputType = TextInputType.text,
    this.maxLength = 25,
    super.key,
  });
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLength;
  final Function? onSubmit;

  final String hintText;
  final TextEditingController controller;
  TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      autofocus: true,
      keyboardType: textInputType,
      controller: controller,
      maxLength: maxLength,
      onSubmitted: (value) async {
        if (onSubmit != null) {
          await onSubmit!();
        }
      },
      decoration: InputDecoration(
        suffix: suffix,
        prefix: prefix,
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
