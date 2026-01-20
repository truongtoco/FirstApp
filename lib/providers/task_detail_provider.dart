import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';

class TaskDetailProvider extends ChangeNotifier {
  final Task originalTask;

  late TextEditingController titleController;
  late List<Task> subTasks;
  bool isCompleted;

  TaskDetailProvider(this.originalTask)
      : isCompleted = originalTask.isCompleted {

    titleController = TextEditingController(text: originalTask.title);

    // Tạo bản sao của Subtask để không ảnh hưởng dữ liệu gốc khi chưa Save
    subTasks = originalTask.subTask.map((e) => Task(
      id: e.id,
      title: e.title,
      isCompleted: e.isCompleted,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    )).toList();
  }

  void toggleTask() {
    isCompleted = !isCompleted;
    for (final s in subTasks) {
      s.isCompleted = isCompleted;
    }
    notifyListeners();
  }

  // Toggle task phụ -> Kiểm tra lại trạng thái task
  void toggleSubTask(String id) {
    final sub = subTasks.firstWhere((e) => e.id == id);
    sub.isCompleted = !sub.isCompleted;

    // Nếu tất cả task phụ xong -> task xong. Nếu 1 task phụ chưa xong -> task chưa xong
    isCompleted = subTasks.isNotEmpty && subTasks.every((e) => e.isCompleted);
    notifyListeners();
  }

  Task buildUpdatedTask() {
    return Task(
      id: originalTask.id,
      title: titleController.text.trim(),
      folder: originalTask.folder,
      subTask: subTasks,
      isCompleted: isCompleted,
      createdAt: originalTask.createdAt,
      updatedAt: DateTime.now(),
      scheduledDate: originalTask.scheduledDate, // Sửa remindAt thành scheduledDate
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}