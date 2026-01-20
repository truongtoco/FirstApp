import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/services/hive_task_service.dart';
import 'package:task_manager_app/services/hive_folder_service.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final HiveTaskService _taskService = HiveTaskService();
  final HiveFolderService _folderService = HiveFolderService();

  List<Task> _tasks = [];
  List<Folder> _folders = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  List<Folder> get folders => _folders;
  bool get isLoading => _isLoading;

  TaskProvider() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _folderService.addDefaultsIfEmpty();

    _folders = await _folderService.getAll();
    _tasks = await _taskService.getAll();

    _isLoading = false;
    notifyListeners();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addTask(Task task) async {
    await _taskService.add(task);
    _tasks = await _taskService.getAll();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _taskService.update(task);
    _tasks = await _taskService.getAll();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.delete(id);
    _tasks = await _taskService.getAll();
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    final task = getTaskById(id);
    if (task == null) return;

    task.isCompleted = !task.isCompleted;
    for (final sub in task.subTask) {
      sub.isCompleted = task.isCompleted;
      sub.updatedAt = DateTime.now();
    }
    task.updatedAt = DateTime.now();

    await _taskService.update(task);
    _tasks = await _taskService.getAll();
    notifyListeners();
  }

  Future<void> toggleSubTask(String taskId, String subTaskId) async {
    final task = getTaskById(taskId);
    if (task == null) return;

    final index = task.subTask.indexWhere((s) => s.id == subTaskId);
    if (index == -1) return;

    final sub = task.subTask[index];
    sub.isCompleted = !sub.isCompleted;
    sub.updatedAt = DateTime.now();

    task.isCompleted = task.subTask.every((s) => s.isCompleted);
    task.updatedAt = DateTime.now();

    await _taskService.update(task);
    _tasks = await _taskService.getAll();
    notifyListeners();
  }

  // ===== Folder =====
  Future<void> addFolder(Folder folder) async {
    await _folderService.add(folder);
    _folders = await _folderService.getAll();
    notifyListeners();
  }

  Future<void> deleteFolder(String id) async {
    await _folderService.delete(id);
    _folders = await _folderService.getAll();
    notifyListeners();
  }

  Future<void> createFolder({
    required String title,
    required IconData icon,
    required Color color,
  }) async {
    final now = DateTime.now();
    final folder = Folder(
      id: const Uuid().v4(),
      title: title,
      icon: icon,
      backgroundColor: color,
      createdAt: now,
      updatedAt: now,
    );
    await _folderService.add(folder);
    _folders = await _folderService.getAll();
    notifyListeners();
  }
}
