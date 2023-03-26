import 'package:api_tester_app/classes/response_class.dart';
import 'package:http/http.dart' as http;

Future<APIResponse> getAPIMethod(
    {required String url, required Map<String, String> headers}) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return APIResponse(
        statusCode: response.statusCode,
        body: response.body,
        isException: false);
  } catch (e) {
    return APIResponse(statusCode: -1, body: e.toString(), isException: true);
  }
}
