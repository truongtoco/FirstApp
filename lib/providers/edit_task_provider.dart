import 'package:flutter/material.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class EditTaskProvider extends ChangeNotifier {
  final Task originalTask;

  // Controllers & State
  late TextEditingController titleCtrl;
  Folder? selectedFolder;
  DateTime? scheduledDate; // Đổi remindAt -> scheduledDate
  List<Task> subTasks = [];

  EditTaskProvider(this.originalTask) {
    titleCtrl = TextEditingController(text: originalTask.title);
    selectedFolder = originalTask.folder;
    scheduledDate = originalTask.scheduledDate;

    // Copy Subtasks --> Để khi sửa subtask ở đây không ảnh hưởng task gốc ngay lập tức
    subTasks = originalTask.subTask.map((e) => Task(
      id: e.id,
      title: e.title,
      isCompleted: e.isCompleted,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    )).toList();
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

  // Thêm subtask
  void addDummySubTask() {
    subTasks.add(Task(
      id: const Uuid().v4(),
      title: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void updateSubTaskTitle(Task sub, String newTitle) {
    sub.title = newTitle;
  }

  // Hàm Build Task mới để chuẩn bị Save
  Task? buildUpdatedTask() {
    if (titleCtrl.text.trim().isEmpty) return null;

    return Task(
      id: originalTask.id, // Giữ nguyên ID cũ
      title: titleCtrl.text.trim(),
      folder: selectedFolder,
      subTask: subTasks,
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