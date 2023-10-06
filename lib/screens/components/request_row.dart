import 'package:api_tester_app/screens/components/request_title.dart';
import 'package:flutter/material.dart';

class RequestRow extends StatelessWidget {
  const RequestRow({super.key, required this.title, required this.data});

  final String title;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RequestTitleText(title: title),
        Expanded(
          child: SelectableText(
            data,
          ),
        ),
      ],
    );
  }
}
