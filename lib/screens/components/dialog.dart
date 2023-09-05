import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import 'custom_text_field.dart';

void showNameDialog({
  required BuildContext context,
  required String title,
  required Function({required String name}) function,
}) {
  final TextEditingController _nameController = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        _nameController.clear();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: CustomTextField(
            label: "Folder name",
            prefix: null,
            onSubmit: () async {
              Navigator.pop(ctx);
              await function(name: _nameController.text.trim());
              _nameController.text.trim();
              _nameController.clear();
            },
            suffix: IconButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await function(name: _nameController.text.trim());
                _nameController.text.trim();
                _nameController.clear();
              },
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.accentColor,
              ),
            ),
            controller: _nameController,
            hintText: "",
          ),
        );
      });
}
