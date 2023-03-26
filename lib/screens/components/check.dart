import 'package:flutter/material.dart';

class StatusCheck extends StatelessWidget {
  const StatusCheck({super.key, required this.isTrue, required this.message});

  final bool isTrue;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Icon(
        isTrue ? Icons.check : Icons.close_rounded,
        color: isTrue ? Colors.green : Colors.redAccent,
      ),
    );
  }
}
