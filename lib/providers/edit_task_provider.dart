import 'package:flutter/material.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class EditTaskProvider extends ChangeNotifier {
  final Task originalTask;

  late TextEditingController titleCtrl;
  Folder? selectedFolder;
  DateTime? scheduledDate;
  List<Task> subTasks = [];

  EditTaskProvider(this.originalTask) {
    titleCtrl = TextEditingController(text: originalTask.title);
    selectedFolder = originalTask.folder;
    scheduledDate = originalTask.scheduledDate;

    subTasks = originalTask.subTasks
        .map(
          (e) => Task(
            id: e.id,
            title: e.title,
            folder: null,
            subTasks: [],
            isCompleted: e.isCompleted,
            scheduledDate: e.scheduledDate,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
          ),
        )
        .toList();
  }

  void setFolder(Folder? folder) {
    selectedFolder = folder;
    notifyListeners();
  }

  void setDateTime(DateTime date) {
    scheduledDate = date;
    notifyListeners();
  }

  void clearDateTime() {
    scheduledDate = null;
    notifyListeners();
  }

  void removeSubTask(Task sub) {
    subTasks.remove(sub);
    notifyListeners();
  }

  void addDummySubTask() {
    subTasks.add(
      Task(
        id: const Uuid().v4(),
        title: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateSubTaskTitle(Task sub, String newTitle) {
    sub.title = newTitle;
  }

  Task? buildUpdatedTask() {
    if (titleCtrl.text.trim().isEmpty) return null;

    return Task(
      id: originalTask.id,
      title: titleCtrl.text.trim(),
      folder: selectedFolder,
      subTasks: subTasks,
      isCompleted: originalTask.isCompleted,
      createdAt: originalTask.createdAt,
      updatedAt: DateTime.now(),
      scheduledDate: scheduledDate,
    );
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }
}
