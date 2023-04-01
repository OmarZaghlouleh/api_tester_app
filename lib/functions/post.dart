import 'dart:convert';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/try_decode.dart';
import 'package:http/http.dart' as http;

Future<APIResponse> postAPIMethod({required APIRequest request}) async {
  try {
    final response = await http.post(
      Uri.parse(request.url),
      headers: request.header.cast(),
      body: request.encodeBody ? jsonEncode(request.body) : request.body,
    );

    return APIResponse(
        statusCode: response.statusCode,
        body: tryDecode(value: response.body),
        isException: false);
  } catch (e) {
    return APIResponse(statusCode: -1, body: e.toString(), isException: true);
  }
}
