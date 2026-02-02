import 'package:hive/hive.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  late Box<Task> _taskBox;

  Future<void> init() async {
    _taskBox = await Hive.openBox<Task>('tasks');

    if (_taskBox.isEmpty) {
      await _createDefaultTasks();
    }
  }

  List<Task> getAllTasks() {
    return _taskBox.values.toList().cast<Task>().reversed.toList();
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  Future<void> deleteAllTasks() async {
    await _taskBox.clear();
  }

  Future<void> _createDefaultTasks() async {
    final now = DateTime.now();

    final task = Task(
      id: const Uuid().v4(),
      title: "Welcome ",
      createdAt: now,
      updatedAt: now,
      scheduledDate: now.add(const Duration(hours: 1)),
      durationMinutes: 60,
      subTasks: [
        Task(
          id: const Uuid().v4(),
          title: "Tap to complete me",
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );

    await _taskBox.put(task.id, task);
  }
}
