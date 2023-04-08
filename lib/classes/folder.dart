// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_tester_app/classes/request_class.dart';

class Folder {
  final String name;
  final List<APIRequest> requests;

  const Folder({
    required this.name,
    required this.requests,
  });

  factory Folder.fromJson(Map<dynamic, dynamic> json) {
    List<APIRequest> requests = [];
    for (var request in List.from(
      json['requests'] ?? [],
    )) {
      requests.add(APIRequest.fromJson(request));
    }
    return Folder(
      name: json['name'] ?? "",
      requests: requests,
    );
  }

  Map<String, dynamic> toJson() {
    List requestsJson = [];
    for (var element in requests) {
      requestsJson.add(element.toJson());
    }
    return {
      'name': name,
      'requests': requestsJson,
    };
  }
}
