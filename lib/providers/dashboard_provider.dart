import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';
import '../models/stat_model.dart';

class DashboardProvider extends ChangeNotifier {
  // ====== SỐ LIỆU TỔNG ======
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;

  // ====== DATA VẼ BIỂU ĐỒ ======
  List<FolderStat> stats = [];

  bool isLoading = true;

  late Box<Task> _taskBox;
  StreamSubscription? _subscription;

  // ====== CONSTRUCTOR ======
  DashboardProvider() {
    _init();
  }

  // ====== INIT ======
  Future<void> _init() async {
    // Mở box task
    _taskBox = Hive.isBoxOpen('tasks')
        ? Hive.box<Task>('tasks')
        : await Hive.openBox<Task>('tasks');

    // Tính lần đầu
    _calculate();

    // 🔥 NGHE MỌI THAY ĐỔI TRONG BOX TASK
    _subscription = _taskBox.watch().listen((_) {
      _calculate();
    });
  }

  // ====== CORE LOGIC ======
  void _calculate() {
    isLoading = true;
    notifyListeners();

    final allTasks = _taskBox.values.toList();

    // ---- A. TỔNG QUAN ----
    totalTasks = allTasks.length;
    completedTasks = allTasks.where((t) => t.isCompleted).length;
    pendingTasks = totalTasks - completedTasks;

    // ---- B. THỐNG KÊ THEO FOLDER ----
    final Map<String, int> counter = {};
    final Map<String, Color> colors = {};
    final Map<String, String> names = {};

    for (final task in allTasks) {
      final folder = task.folder;

      final String key = folder?.id ?? 'unclassified';

      counter[key] = (counter[key] ?? 0) + 1;

      names[key] = folder?.title ?? 'Chưa phân loại';
      colors[key] = Color(folder?.colorValue ?? 0xFF9E9E9E);
    }

    stats = counter.entries.map((e) {
      return FolderStat(
        folderName: names[e.key]!,
        count: e.value,
        color: colors[e.key]!,
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  // ====== CLEAN UP ======
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
