import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';

class DatabaseService {
  // --- SINGLETON PATTERN ---
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Hàm khởi động toàn bộ Database
  Future<void> initialize() async {
    // 1. Khởi tạo Hive
    await Hive.initFlutter();

    // 2. Đăng ký các Adapter
    _registerAdapters();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FolderAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }
  }
}