import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final List<Folder> _folders = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Folder> get folders => List.unmodifiable(_folders);

  TaskProvider() {
    init();
  }

  void addFolder(Folder folder) {
    _folders.add(folder);
    notifyListeners();
  }

  Task getTaskById(String id) {
    return _tasks.firstWhere((t) => t.id == id);
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(
    updatedTask, {
    required String taskId,
    required String title,
    Folder? folder,
    DateTime? remindAt,
    required List<Task> subTasks,
  }) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final old = _tasks[index];

    _tasks[index] = Task(
      id: old.id,
      title: title,
      folder: folder ?? old.folder,
      subTask: subTasks,
      isCompleted: old.isCompleted,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
      remindAt: remindAt ?? old.remindAt,
    );

    notifyListeners();
  }

  void updateTaskTitle({required String taskId, required String title}) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final old = _tasks[index];

    _tasks[index] = Task(
      id: old.id,
      title: title,
      folder: old.folder,
      subTask: old.subTask,
      isCompleted: old.isCompleted,
      createdAt: old.createdAt,
      updatedAt: DateTime.now(),
      remindAt: old.remindAt,
    );

    notifyListeners();
  }

  void toggleTask(String id) {
    final task = getTaskById(id);
    task.isCompleted = !task.isCompleted;

    for (final sub in task.subTask) {
      sub.isCompleted = task.isCompleted;
    }

    notifyListeners();
  }

  void toggleSubTask(String taskId, String subTaskId) {
    final task = getTaskById(taskId);
    final sub = task.subTask.firstWhere((s) => s.id == subTaskId);

    sub.isCompleted = !sub.isCompleted;
    task.isCompleted = task.subTask.every((s) => s.isCompleted);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> init() async {
    if (_folders.isNotEmpty || _tasks.isNotEmpty) return;

    await Future.delayed(const Duration(milliseconds: 300));

    final uuid = Uuid();
    final now = DateTime.now();

    final health = Folder(
      id: uuid.v4(),
      title: "Health",
      icon: Icons.favorite,
      backgroundColor: const Color(0xff7990F8),
      createdAt: now,
      updatedAt: now,
    );

    final work = Folder(
      id: uuid.v4(),
      title: "Work",
      icon: Icons.work,
      backgroundColor: const Color(0xff46CF8B),
      createdAt: now,
      updatedAt: now,
    );

    final mental = Folder(
      id: uuid.v4(),
      title: "Mental Health",
      icon: Icons.spa,
      backgroundColor: const Color(0xffBC5EAD),
      createdAt: now,
      updatedAt: now,
    );

    final others = Folder(
      id: uuid.v4(),
      title: "Others",
      icon: Icons.folder,
      backgroundColor: const Color(0xff908986),
      createdAt: now,
      updatedAt: now,
    );

    _folders.addAll([health, work, mental, others]);

    _tasks.addAll([
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        folder: health,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: "Edit the PDF",
        folder: work,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: "Write in a gratitude journal",
        folder: mental,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: "Stretch everyday for 15 mins",
        folder: health,
        createdAt: now,
        updatedAt: now,
        subTask: [
          Task(
            id: uuid.v4(),
            title: "Morning stretch",
            createdAt: now,
            updatedAt: now,
          ),
          Task(
            id: uuid.v4(),
            title: "Evening stretch",
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
    ]);

    notifyListeners();
  }
}
