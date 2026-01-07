import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/folder.dart'; // Import Model để đăng ký Adapter
import 'package:task_manager_app/models/task.dart';   // Import Model để đăng ký Adapter
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/home_screens.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Task>('tasks');

  runApp(const Main());
}
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
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