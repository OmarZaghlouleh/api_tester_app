import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/functions/try_decode.dart';
import 'package:http/http.dart' as http;

Future<APIResponse> getAPIMethod({required APIRequest request}) async {
  try {
    final response = await http.get(
      Uri.parse(request.url),
      headers: request.header.cast(),
    );

    return APIResponse(
        statusCode: response.statusCode,
        body: tryDecode(value: response.body),
        isException: false);
  } catch (e) {
    return APIResponse(statusCode: -1, body: e.toString(), isException: true);
  }
}
