import 'package:api_tester_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool showDeleteDialog({
  required BuildContext context,
  required Function confirmFunction,
}) {
  bool ans = false;
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Text(
            "Are you sure to delete this test ?",
            style: GoogleFonts.laila(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: AppColors.errorColor,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  ans = false;
                  Navigator.pop(ctx);
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.laila(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.successColor,
                  ),
                )),
            TextButton(
              onPressed: () async {
                ans = true;
                Navigator.pop(ctx);
                await confirmFunction();
              },
              child: Text(
                "Yes",
                style: GoogleFonts.laila(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.errorColor,
                ),
              ),
            )
          ],
        );
      });
  return ans;
}
