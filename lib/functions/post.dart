import 'dart:convert';
import 'dart:developer';

import 'package:api_tester_app/classes/response_class.dart';
import 'package:http/http.dart' as http;

Future<APIResponse> postAPIMethod({
  required String url,
  required Map<String, String> headers,
  required Map<String, dynamic> body,
}) async {
  try {
    log(body.toString());
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    return APIResponse(
        statusCode: response.statusCode,
        body: response.body,
        isException: false);
  } catch (e) {
    return APIResponse(statusCode: -1, body: e.toString(), isException: true);
  }
}
