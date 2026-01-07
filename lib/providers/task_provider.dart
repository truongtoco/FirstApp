import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> _tasksBox = Hive.box<Task>('tasks');
  final Box<Folder> _foldersBox = Hive.box<Folder>('folders');

  List<Task> get tasks => _tasksBox.values.toList().cast<Task>().reversed.toList();

  List<Folder> get folders => _foldersBox.values.toList().cast<Folder>();

  bool isLoading = false;

  TaskProvider() {
    init();
  }

  Future<void> init() async {
    if (_foldersBox.isEmpty) {
      isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      final uuid = const Uuid();

      final defaultFolders = [
        Folder(
          id: uuid.v4(),
          title: "Health",
          iconCode: Icons.favorite.codePoint,
          colorValue: const Color(0xff7990F8).value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Folder(
          id: uuid.v4(),
          title: "Work",
          iconCode: Icons.work.codePoint,
          colorValue: const Color(0xff46CF8B).value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Folder(
          id: uuid.v4(),
          title: "Mental Health",
          iconCode: Icons.spa.codePoint,
          colorValue: const Color(0xffBC5EAD).value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Folder(
          id: uuid.v4(),
          title: "Others",
          iconCode: Icons.folder.codePoint,
          colorValue: const Color(0xff908986).value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (var folder in defaultFolders) {
        await _foldersBox.put(folder.id, folder);
      }

      isLoading = false;
      notifyListeners();
    }
  }

  void addTask(Task newTask) {
    _tasksBox.put(newTask.id, newTask);
    notifyListeners();
  }

  void toggleTaskStatus(String taskId) {
    final task = _tasksBox.get(taskId);

    if (task != null) {
      task.isCompleted = !task.isCompleted;
      task.save();
      notifyListeners();
    }
    else {
      for (var t in _tasksBox.values) {
        if (t.subTask.isNotEmpty) {

        }
      }
    }
  }

  Folder? getFolderById(String? id) {
    if (id == null) return null;
    return _foldersBox.get(id);
  }
}