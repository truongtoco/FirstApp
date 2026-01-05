import 'package:task_manager_app/models/folder.dart';

class Task {
  String id;
  String title;
  Folder? folder;
  List<Task> subTask;
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? remindAt;

  Task({
    required this.id,
    required this.title,
    this.folder,
    List<Task>? subTask,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.remindAt,
  }) : subTask = subTask ?? [];

  copyWith({required String title}) {}
}
