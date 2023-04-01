// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:api_tester_app/functions/try_decode.dart';

class APIResponse {
  final int statusCode;
  final String body;
  final bool isException;

  factory APIResponse.fromJson(Map<dynamic, dynamic> json) {
    //json = json.cast<String, dynamic>();
    return APIResponse(
      statusCode: json['statusCode'] ?? -1,
      isException: json['isException'] ?? true,
      body: tryDecode(value: json['body'].toString()),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        'statusCode': statusCode,
        'isException': isException,
        'body': body,
      };

  const APIResponse({
    required this.statusCode,
    required this.isException,
    required this.body,
  });
}
