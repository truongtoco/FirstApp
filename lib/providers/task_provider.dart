import 'package:flutter/material.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/services/folder_service.dart';
import 'package:task_manager_app/services/task_service.dart';

class TaskViewModel extends ChangeNotifier {
  // Gọi 2 Service Singleton
  final FolderService _folderService = FolderService();
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  List<Folder> _folders = [];

  List<Task> get tasks => _tasks;
  List<Folder> get folders => _folders;

  bool isLoading = false;

  TaskViewModel() {
    loadData();
  }

  void loadData() {
    isLoading = true;
    notifyListeners();

    _folders = _folderService.getAllFolders();
    _tasks = _taskService.getAllTasks();

    isLoading = false;
    notifyListeners();
  }

  void addTask(Task newTask) async {
    await _taskService.addTask(newTask);
    // Reload lại list sau khi thêm để UI cập nhật task mới nhất
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String taskId) async {
    // Tìm task trong list hiện tại để xử lý
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      task.isCompleted = !task.isCompleted;
      // Gọi service lưu xuống Database
      await _taskService.updateTask(task);
      notifyListeners();
    }
  }

  // Lấy Folder Object từ ID
  Folder? getFolderById(String? id) {
    if (id == null) return null;
    return _folderService.getFolderById(id);
  }
  Future<void> updateTask(Task task) async {
    // 1. Gọi Service để lưu thay đổi xuống Hive Database
    await _taskService.updateTask(task);

    // 2. Cập nhật lại danh sách hiển thị trên UI
    _tasks = _taskService.getAllTasks();
    notifyListeners();
  }
  void addFolder(Folder newFolder) async {
    await _folderService.addFolder(newFolder);
    _folders = _folderService.getAllFolders();
    notifyListeners();
  }
  // Hàm xóa task
  Future<void> deleteTask(String taskId) async{
    // Gọi service xóa data trong Database
    await _taskService.deleteTask(taskId);
    // Xóa khỏi list trên UI
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
  // 1. Tổng số Task
  int get totalTasks => _tasks.length;

  // 2. Số Task đã hoàn thành
  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;

  // 3. Số Task đang chờ
  int get pendingTasksCount => _tasks.where((t) => !t.isCompleted).length;

  // 4. Tỷ lệ hoàn thành (0.0 -> 1.0)
  double get completionPercentage {
    if (_tasks.isEmpty) return 0.0;
    return completedTasksCount / totalTasks;
  }

  // 5. Thống kê Task theo Folder (Để vẽ biểu đồ tròn)
  // Trả về Map: {Folder: Số lượng task}
  Map<Folder, int> get tasksPerFolder {
    Map<Folder, int> stats = {};

    // Lấy danh sách các folder đang có
    for (var folder in _folders) {
      // Đếm số task thuộc folder này
      int count = _tasks.where((t) => t.folder?.id == folder.id).length;
      if (count > 0) {
        stats[folder] = count;
      }
    }

    // Đếm số task không có folder (Others)
    int noFolderCount = _tasks.where((t) => t.folder == null).length;
    if (noFolderCount > 0) {
      // Tạo một Folder ảo để hiển thị
      final other = Folder(
          id: 'other',
          title: 'Others',
          iconCode: 0, // Icon ảo
          colorValue: 0xFF9E9E9E, // Màu xám
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()
      );
      stats[other] = noFolderCount;
    }

    return stats;
  }
}