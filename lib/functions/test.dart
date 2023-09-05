import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';
import 'package:api_tester_app/enums/request_types.dart';
import 'package:api_tester_app/functions/delete.dart';
import 'package:api_tester_app/functions/get.dart';
import 'package:api_tester_app/functions/post.dart';
import 'package:api_tester_app/functions/put.dart';
import 'package:api_tester_app/functions/storage_functions.dart';

Future<APIResponse> testAPI({required APIRequest request}) async {
  APIResponse response;
  switch (request.method) {
    case RequestTypes.get:
      response = await getAPIMethod(request: request);
      break;
    case RequestTypes.post:
      response = await postAPIMethod(request: request);
      break;
    case RequestTypes.put:
      response = await putAPIMethod(request: request);
      break;
    case RequestTypes.delete:
      response = await deleteAPIMethod(request: request);
      break;
  }
  await saveToStorage(request: request, response: response);

  return response;
}
