import 'dart:developer';

import 'package:api_tester_app/classes/debouncer.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.label,
    required this.prefix,
    required this.controller,
    required this.hintText,
    this.textInputType = TextInputType.text,
    super.key,
  });
  final String label;
  final Widget? prefix;
  final String hintText;
  final TextEditingController controller;
  TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
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
