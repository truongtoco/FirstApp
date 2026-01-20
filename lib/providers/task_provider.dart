import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/services/task_service.dart';
import 'package:task_manager_app/services/folder_service.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  final FolderService _folderService = FolderService();

  List<Task> _tasks = [];
  List<Folder> _folders = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  List<Folder> get folders => _folders;
  bool get isLoading => _isLoading;

  TaskProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // Service đã được init ở main()
    _folders = _folderService.getAllFolders();
    _tasks = _taskService.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  // ===== TASK =====
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addTask(Task task) async {
    await _taskService.addTask(task);
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    task.updatedAt = DateTime.now();
    await task.save();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    final task = getTaskById(id);
    if (task == null) return;

    final newCompleted = !task.isCompleted;

    final newSubTasks = task.subTasks
        .map(
          (sub) => sub.copyWith(
            isCompleted: newCompleted,
            updatedAt: DateTime.now(),
          ),
        )
        .toList();

    final updatedTask = task.copyWith(
      isCompleted: newCompleted,
      subTasks: newSubTasks,
      updatedAt: DateTime.now(),
    );

    await _taskService.updateTask(updatedTask);
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  Future<void> toggleSubTask(String taskId, String subTaskId) async {
    final task = getTaskById(taskId);
    if (task == null) return;

    final newSubTasks = task.subTasks.map((sub) {
      if (sub.id == subTaskId) {
        return sub.copyWith(
          isCompleted: !sub.isCompleted,
          updatedAt: DateTime.now(),
        );
      }
      return sub;
    }).toList();

    final isCompleted = newSubTasks.every((s) => s.isCompleted);

    final updatedTask = task.copyWith(
      subTasks: newSubTasks,
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );

    await _taskService.updateTask(updatedTask);
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  // ===== FOLDER =====
  Future<void> addFolder(Folder folder) async {
    await _folderService.addFolder(folder);
    _folders = _folderService.getAllFolders();
    notifyListeners();
  }

  Future<void> deleteFolder(String id) async {
    // Bạn chưa có deleteFolder trong service
    // 👉 nếu cần mình sẽ viết thêm cho bạn
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
      iconCode: icon.codePoint,
      colorValue: color.value,
      createdAt: now,
      updatedAt: now,
    );

    await _folderService.addFolder(folder);
    _folders = _folderService.getAllFolders();
    notifyListeners();
  }
}
