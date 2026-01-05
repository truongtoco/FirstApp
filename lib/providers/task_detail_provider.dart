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
    subTasks = originalTask.subTask
        .map(
          (e) => Task(
            id: e.id,
            title: e.title,
            isCompleted: e.isCompleted,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
  }

  void toggleTask() {
    isCompleted = !isCompleted;
    for (final s in subTasks) {
      s.isCompleted = isCompleted;
    }
    notifyListeners();
  }

  void toggleSubTask(String id) {
    final sub = subTasks.firstWhere((e) => e.id == id);
    sub.isCompleted = !sub.isCompleted;
    isCompleted = subTasks.every((e) => e.isCompleted);
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
      remindAt: originalTask.remindAt,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
