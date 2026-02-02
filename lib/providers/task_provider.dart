import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/services/task_service.dart';
import 'package:task_manager_app/services/folder_service.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager_app/services/notification_service.dart';

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
  List<Task> tasksByDate(DateTime date) {
    return tasks.where((task) {
      if (task.remindAt == null) return false;

      final d = task.remindAt!;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _folders = _folderService.getAllFolders();
    _tasks = _taskService.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addTask(Task task) async {
    await _taskService.addTask(task);
    if (task.remindAt != null) {
      try {
        await NotificationService().setAlarm(
          id: task.id.hashCode,
          title: 'Task reminder',
          body: task.title,
          time: task.remindAt!,
        );
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
    }
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await NotificationService().cancel(task.id.hashCode);
    await task.save();
    if (task.remindAt != null && task.remindAt!.isAfter(DateTime.now())) {
      await NotificationService().setAlarm(
        id: task.id.hashCode,
        title: 'Task reminder',
        body: task.title,
        time: task.remindAt!,
      );
    }

    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  List<Task> tasksForDay(DateTime day) {
    return _tasks.where((t) {
      if (t.scheduledDate == null) return false;
      return DateUtils.isSameDay(t.scheduledDate, day);
    }).toList();
  }

  Future<void> deleteTask(String id) async {
    await NotificationService().cancel(id.hashCode);
    await _taskService.deleteTask(id);
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final newCompleted = !task.isCompleted;

    _tasks[index] = task.copyWith(
      isCompleted: newCompleted,
      subTasks: task.subTasks
          .map((s) => s.copyWith(isCompleted: newCompleted))
          .toList(),
      updatedAt: DateTime.now(),
    );

    notifyListeners();

    await _taskService.updateTask(_tasks[index]);
  }

  Future<void> toggleSubTask(String taskId, String subTaskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _tasks[index];

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

    _tasks[index] = task.copyWith(
      subTasks: newSubTasks,
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );

    notifyListeners();

    await _taskService.updateTask(_tasks[index]);
  }

  Future<void> addFolder(Folder folder) async {
    await _folderService.addFolder(folder);
    _folders = _folderService.getAllFolders();
    notifyListeners();
  }

  Future<void> deleteFolder(String id) async {
    try {
      await _folderService.deleteFolder(id);
      _tasks = _tasks.map((task) {
        if (task.folder?.id == id) {
          return task.copyWith(folder: null, updatedAt: DateTime.now());
        }
        return task;
      }).toList();

      _folders = _folderService.getAllFolders();

      notifyListeners();
    } catch (e) {
      debugPrint('Delete folder error: $e');
    }
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
