import 'package:hive/hive.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  // --- SINGLETON PATTERN ---
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

  // Lấy toàn bộ danh sách Task
  List<Task> getAllTasks() {
    return _taskBox.values.toList().cast<Task>().reversed.toList();
  }

  // Thêm Task mới
  Future<void> addTask(Task task) async {
    // Dùng ID của task làm key để dễ truy xuất
    await _taskBox.put(task.id, task);
  }

  // Cập nhật Task
  Future<void> updateTask(Task task) async {
    // Hàm này tự tìm vị trí của nó trong Box và ghi đè
    await task.save();
  }

  // Xóa Task theo ID
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  // Xóa toàn bộ Task
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
