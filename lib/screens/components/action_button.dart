import 'package:api_tester_app/controllers/home_provider.dart';
import 'package:api_tester_app/utils/colors.dart';
import 'package:api_tester_app/utils/shadows.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.title, required this.function});

  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await function();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: CustomShadow.shadows,
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
          //borderRadius: BorderRadius.circular(8),
        ),
        child: Consumer<HomeProvider>(
          builder: (context, value, child) => value.getIsLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.buttonTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
