import 'package:api_tester_app/screens/components/request_title.dart';
import 'package:flutter/material.dart';

class RequestRow extends StatelessWidget {
  const RequestRow({
    super.key,
    required this.title,
    required this.data,
    required this.textColor,
  });

  final String title;
  final String data;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RequestTitleText(title: title),
        Expanded(
          child: Text(
            data,
            style: TextStyle(color: textColor),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
