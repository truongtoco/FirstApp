import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/providers/dashboard_provider.dart';
import 'package:task_manager_app/services/database_service.dart';
import 'package:task_manager_app/services/folder_service.dart';
import 'package:task_manager_app/services/task_service.dart';
import 'package:task_manager_app/screens/home_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive + Đăng ký Adapter (FolderAdapter, TaskAdapter)
  await DatabaseService().initialize();

  // Mở các Box dữ liệu
  await FolderService().init();
  await TaskService().init();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        themeMode: ThemeMode.light,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreens(),
      ),
    );
  }
}