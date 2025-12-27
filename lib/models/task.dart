import 'package:task_manager_app/models/folder.dart';

class Task {
  String id;
  String title;
  Folder? folder;
  List<Task> subTask; // ? hoặc khi khởi tạo đối tượng mình có thể để là []
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.folder,
    this.subTask = const [],
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
