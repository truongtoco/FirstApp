import 'package:flutter/material.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class NewTaskProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();

  final List<TextEditingController> subtaskControllers = [];

  Folder? selectedFolder;
  DateTime? selectedDateTime;
  bool canSave = false;

  NewTaskProvider() {
    titleController.addListener(_validateForm);
  }

  void _validateForm() {
    // Phải có Title thì mới cho Save
    final isValid = titleController.text.trim().isNotEmpty;
    if (canSave != isValid) {
      canSave = isValid;
      notifyListeners();
    }
  }

  void selectFolder(Folder folder) {
    if (selectedFolder?.id == folder.id) {
      selectedFolder = null;
    } else {
      selectedFolder = folder;
    }
    notifyListeners();
  }

  void selectDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  void addSubtaskField() {
    subtaskControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeSubtaskField(int index) {
    subtaskControllers[index].dispose();
    subtaskControllers.removeAt(index);
    notifyListeners();
  }

  // Hàm gom data từ form lại thành 1 object Task hoàn chỉnh
  Task? buildTask() {
    if (!canSave) return null;

    final uuid = const Uuid();
    final now = DateTime.now();

    List<Task> validSubtasks = [];
    for (var controller in subtaskControllers) {
      if (controller.text.trim().isNotEmpty) {
        validSubtasks.add(Task(
          id: uuid.v4(),
          title: controller.text.trim(),
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    return Task(
      id: uuid.v4(),
      title: titleController.text.trim(),
      folder: selectedFolder,
      subTask: validSubtasks,
      createdAt: now,
      updatedAt: now,
      scheduledDate: selectedDateTime,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var c in subtaskControllers) {
      c.dispose();
    }
    super.dispose();
  }
}