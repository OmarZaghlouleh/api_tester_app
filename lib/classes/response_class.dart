// ignore_for_file: public_member_api_docs, sort_constructors_first
class APIResponse {
  final int statusCode;
  final String body;
  final bool isException;

  const APIResponse({
    required this.statusCode,
    required this.isException,
    required this.body,
  });
}
