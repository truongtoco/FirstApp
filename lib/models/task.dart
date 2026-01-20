import 'package:hive/hive.dart';
import 'package:task_manager_app/models/folder.dart';
part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  Folder? folder;

  @HiveField(3)
  List<Task> subTask;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  DateTime? scheduledDate;

  Task({
    required this.id,
    required this.title,
    this.folder,
    this.subTask = const [],
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledDate,
  });
}