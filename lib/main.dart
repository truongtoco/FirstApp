import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/services/database_service.dart';
import 'package:task_manager_app/services/folder_service.dart';
import 'package:task_manager_app/services/task_service.dart';
import 'package:task_manager_app/screens/home_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive + Adapters
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
        ChangeNotifierProvider(create: (_) => TaskViewModel())
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            )
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreens(),
      ),
    );
  }
}