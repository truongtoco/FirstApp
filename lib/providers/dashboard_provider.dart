import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stat_model.dart';
import '../models/task.dart';

class DashboardProvider extends ChangeNotifier {
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;
  List<FolderStat> stats = []; // Dữ liệu để vẽ biểu đồ tròn
  bool isLoading = false;

  final String taskBoxName = 'tasks';

  Future<void> loadStats() async {
    isLoading = true;
    notifyListeners();

    try {
      // Mở box nếu chưa mở
      final box = Hive.isBoxOpen(taskBoxName)
          ? Hive.box<Task>(taskBoxName)
          : await Hive.openBox<Task>(taskBoxName);

      final allTasks = box.values.toList();

      // --- A. TÍNH SỐ LIỆU TỔNG QUAN ---
      totalTasks = allTasks.length;
      completedTasks = allTasks.where((t) => t.isCompleted).length;
      pendingTasks = totalTasks - completedTasks;

      // --- B. TÍNH SỐ LIỆU THEO FOLDER ---
      // Map dùng để đếm
      Map<String, int> counter = {};
      // Map dùng để lưu màu
      Map<String, Color> colors = {};

      for (var task in allTasks) {
        // Lấy folder từ task
        final folder = task.folder;

        // Xử lý tên folder (Nếu null thì gom vào nhóm "Chưa phân loại")
        String name = folder?.title ?? 'Chưa phân loại';

        // Xử lý màu (Nếu null thì lấy màu Xám)
        int colorVal = folder?.colorValue ?? 0xFF9E9E9E;

        // Cộng dồn số lượng
        if (counter.containsKey(name)) {
          counter[name] = counter[name]! + 1;
        } else {
          counter[name] = 1;
          colors[name] = Color(colorVal);
        }
      }

      // Chuyển từ Map sang List<FolderStat>
      stats = counter.entries.map((e) {
        return FolderStat(
          folderName: e.key,
          count: e.value,
          color: colors[e.key]!,
        );
      }).toList();

    } catch (e) {
      print("Lỗi Dashboard: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}