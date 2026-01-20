import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:uuid/uuid.dart';

class NewTaskProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final List<TextEditingController> subtaskControllers = [];

  Folder? selectedFolder;
  DateTime? selectedDateTime;

  void selectFolder(Folder folder) {
    selectedFolder = folder;
    notifyListeners();
  }

  void selectDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  void addSubtask() {
    subtaskControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeSubtask(int index) {
    subtaskControllers[index].dispose();
    subtaskControllers.removeAt(index);
    notifyListeners();
  }

  Task? buildTask() {
    if (titleController.text.trim().isEmpty) return null;
    if (selectedFolder == null) return null;

    final now = DateTime.now();

    final subTasks = subtaskControllers
        .where((c) => c.text.trim().isNotEmpty)
        .map(
          (c) => Task(
            id: const Uuid().v4(),
            title: c.text.trim(),
            createdAt: now,
            updatedAt: now,
          ),
        )
        .toList();

    return Task(
      id: const Uuid().v4(),
      title: titleController.text.trim(),
      folder: selectedFolder,
      subTasks: subTasks,
      createdAt: now,
      updatedAt: now,
      remindAt: selectedDateTime,
    );
  }

  void clear() {
    titleController.clear();
    for (final c in subtaskControllers) {
      c.dispose();
    }
    subtaskControllers.clear();
    selectedFolder = null;
    selectedDateTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    for (final c in subtaskControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
