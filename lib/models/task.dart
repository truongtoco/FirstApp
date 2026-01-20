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
  List<Task> subTasks;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime updatedAt;

  @HiveField(7)
  DateTime? scheduledDate;

  @HiveField(8)
  DateTime? remindAt;

  Task({
    required this.id,
    required this.title,
    this.folder,
    List<Task>? subTasks,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledDate,
    this.remindAt,
  }) : subTasks = subTasks ?? [];

  Task copyWith({
    String? title,
    bool? isCompleted,
    List<Task>? subTasks,
    Folder? folder,
    DateTime? scheduledDate,
    DateTime? remindAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      folder: folder ?? this.folder,
      subTasks: subTasks ?? this.subTasks,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      scheduledDate: scheduledDate ?? this.scheduledDate,
      remindAt: remindAt ?? this.remindAt,
    );
  }
}
