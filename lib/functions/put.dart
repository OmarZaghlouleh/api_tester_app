import 'dart:convert';

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/try_decode.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

Future<APIResponse> putAPIMethod({required APIRequest request}) async {
  try {
    if (!request.encodeBody) {
      final dio = Dio();

      final response = await dio.put(
        request.url,
        data: request.body,
        options: Options(
          headers: request.header.cast(),
        ),
      );
      return APIResponse(
          statusCode: response.statusCode ?? -1,
          body: tryDecode(value: response.data),
          isException: false);
    } else {
      final response = await http.put(
        Uri.parse(request.url),
        headers: request.header.cast(),
        body: jsonEncode(request.body),
      );

      return APIResponse(
          statusCode: response.statusCode,
          body: tryDecode(value: response.body),
          isException: false);
    }
  } catch (e) {
    return APIResponse(statusCode: -1, body: e.toString(), isException: true);
  }
}
