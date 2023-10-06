// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_tester_app/classes/request_class.dart';
import 'package:api_tester_app/classes/response_class.dart';

class Folder {
  final String name;
  final List<MapEntry<APIRequest, APIResponse>> requests;

  const Folder({
    required this.name,
    required this.requests,
  });

  factory Folder.fromJson(Map<dynamic, dynamic> json) {
    List requestsFromJson = json['requests'] as List;
    List<MapEntry<APIRequest, APIResponse>> requests = [];
    for (var element in requestsFromJson) {
      final data = element.entries.first;

      APIRequest request = APIRequest.fromJson(data.key);
      APIResponse response = APIResponse.fromJson(data.value);
      requests.add(MapEntry(request, response));
    }

    return Folder(name: json['name'] ?? "", requests: requests);
  }

  Map<String, dynamic> toJson() {
    List requestsToJson = [];
    for (var element in requests) {
      requestsToJson.add({element.key.toJson(): element.key.toJson()});
    }

    return {
      'name': name,
      'requests': requestsToJson,
    };
  }
}
