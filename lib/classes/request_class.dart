// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_tester_app/enums/request_types.dart';

class APIRequest {
  String url;
  Map<dynamic, dynamic> parameters;
  Map<dynamic, dynamic> header;
  Map<dynamic, dynamic> body;
  bool encodeBody;
  RequestTypes method;

  factory APIRequest.empty() => APIRequest(
      url: "",
      parameters: {},
      header: {},
      body: {},
      encodeBody: false,
      method: RequestTypes.get);

  factory APIRequest.fromJson(Map<dynamic, dynamic> json) {
    //json = json.cast<String, dynamic>();
    //log(json['parameters'].runtimeType.toString());
    return APIRequest(
      url: json['url'] ?? "",
      parameters: json['parameters'] ?? {},
      header: json['header'] ?? {},
      body: json['body'] ?? {},
      encodeBody: json['encodedBody'] ?? false,
      method: getMethodFromString(value: json['method'] ?? ""),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "url": url,
        "header": header,
        "parameters": parameters,
        'body': body,
        'encodedBody': encodeBody,
        'method': method.name,
      };

  APIRequest({
    required this.url,
    required this.parameters,
    required this.header,
    required this.body,
    required this.method,
    this.encodeBody = false,
  });
}
