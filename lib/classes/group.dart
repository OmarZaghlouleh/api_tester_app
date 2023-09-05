// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_tester_app/classes/folder.dart';

class Group {
  final String name;
  final List<Folder> folders;

  const Group({
    required this.name,
    required this.folders,
  });
  factory Group.empty() => const Group(name: "", folders: []);

  factory Group.fromJson(Map<dynamic, dynamic> json) {
    List<Folder> folders = [];
    for (var folder in List.from(
      json['folders'] ?? [],
    )) {
      folders.add(Folder.fromJson(folder));
    }
    return Group(name: json['name'] ?? "", folders: folders);
  }

  Map<String, dynamic> toJson() {
    List foldersJson = [];
    for (var element in folders) {
      foldersJson.add(element.toJson());
    }
    return {
      'name': name,
      'folders': foldersJson,
    };
  }
}
