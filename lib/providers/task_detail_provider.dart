import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class TaskDetailProvider extends ChangeNotifier {
  final TaskProvider taskProvider;
  final String taskId;

  late TextEditingController titleController;

  TaskDetailProvider({required this.taskProvider, required this.taskId}) {
    final task = taskProvider.getTaskById(taskId)!;
    titleController = TextEditingController(text: task.title);
  }

  Task get task => taskProvider.getTaskById(taskId)!;

  List<Task> get subTasks => task.subTasks;

  bool get isCompleted => task.isCompleted;

  Future<void> toggleTask() async {
    await taskProvider.toggleTask(taskId);
    notifyListeners();
  }

  Future<void> toggleSubTask(String subId) async {
    await taskProvider.toggleSubTask(taskId, subId);
    notifyListeners();
  }

  Future<void> saveTitle() async {
    final updated = task.copyWith(
      title: titleController.text.trim(),
      updatedAt: DateTime.now(),
      subTasks: [],
    );

    await taskProvider.updateTask(updated);
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
